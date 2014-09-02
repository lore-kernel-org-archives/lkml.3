Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaIBLh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:37:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40022 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198AbaIBLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:37:12 -0400
Date: Tue, 2 Sep 2014 12:36:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v10 03/19] arm: fiq: Replace default FIQ handler
Message-ID: <20140902113655.GO30401@n2100.arm.linux.org.uk>
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org> <20140819173742.GG30401@n2100.arm.linux.org.uk> <53F39377.1070308@linaro.org> <20140828150112.GD30401@n2100.arm.linux.org.uk> <53FF50B1.20009@linaro.org> <20140828161551.GC5001@linux.vnet.ibm.com> <5405A3EF.60908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5405A3EF.60908@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:03:11PM +0100, Daniel Thompson wrote:
> On 28/08/14 17:15, Paul E. McKenney wrote:
> > On Thu, Aug 28, 2014 at 04:54:25PM +0100, Daniel Thompson wrote:
> >> On 28/08/14 16:01, Russell King - ARM Linux wrote:
> >>> There's concerns with whether either printk() in check_flags() could
> >>> be reached too (flags there should always indicate that IRQs were
> >>> disabled, so that reduces down to a question about just the first
> >>> printk() there.)
> >>>
> >>> There's also the very_verbose() stuff for RCU lockdep classes which
> >>> Paul says must not be enabled.
> >>>
> >>> Lastly, Paul isn't a lockdep expert, but he sees nothing that prevents
> >>> lockdep doing the deadlock checking as a result of the above call.
> >>>
> >>> So... this coupled with my feeling that notifiers make it too easy for
> >>> unreviewed code to be hooked into this path, I'm fairly sure that we
> >>> don't want to be calling atomic notifier chains from FIQ context.
> 
> Having esablished (above) that RCU usage is safe from FIQ I have been
> working on the assumption that your feeling regarding unreviewed code
> is sufficient on its own to avoid using notifiers (and also to avoid
> a list of function pointers like on x86).

I'm assuming that "your" above refers to Paul here, since you addressed
your message To: Paul and only copied me for information purposes.

If not, please address your message more appropriately so as to avoid
confusion.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
