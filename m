Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbbAIQsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:48:23 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55965 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751954AbbAIQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:48:22 -0500
Date: Fri, 9 Jan 2015 16:48:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 3.19-rc2 v13 4/5] ARM: Add support for on-demand
 backtrace of other CPUs
Message-ID: <20150109164801.GW12302@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
 <1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
 <1420469699-25350-5-git-send-email-daniel.thompson@linaro.org>
 <20150105101925.64e8ecec@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105101925.64e8ecec@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 10:19:25AM -0500, Steven Rostedt wrote:
> On Mon,  5 Jan 2015 14:54:58 +0000
> Daniel Thompson <daniel.thompson@linaro.org> wrote:
> > +/* For reliability, we're prepared to waste bits here. */
> > +static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> > +static  cpumask_t printtrace_mask;
> > +
> > +#define NMI_BUF_SIZE		4096
> > +
> > +struct nmi_seq_buf {
> > +	unsigned char		buffer[NMI_BUF_SIZE];
> > +	struct seq_buf		seq;
> > +};

Am I missing something or does this limit us to 4096 characters of
backtrace output per CPU?

> This is the same code as in x86. I wonder if we should move the
> duplicate code into kernel/printk/ and have it compiled if the arch
> requests it (CONFIG_ARCH_WANT_NMI_PRINTK or something). That way we
> don't have 20 copies of the same nmi_vprintk() and later find that we
> need to change it, and have to change it in 20 different archs.

Agreed, though I wonder about the buffer size.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
