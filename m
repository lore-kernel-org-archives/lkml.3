Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab3AQK4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:56:20 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:48025 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752776Ab3AQK4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:56:18 -0500
Date: Thu, 17 Jan 2013 10:55:45 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pratik Patel <pratikp@codeaurora.org>
Cc: Jon Hunter <jon-hunter@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "magnus.p.persson@stericsson.com" <magnus.p.persson@stericsson.com>,
        "david.rusling@linaro.org" <david.rusling@linaro.org>,
        "arve@android.com" <arve@android.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "d-deao@ti.com" <d-deao@ti.com>,
        "christian.bejram@stericsson.com" <christian.bejram@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: CoreSight framework and drivers
Message-ID: <20130117105545.GB3699@mudshark.cambridge.arm.com>
References: <50D1F37E.6000804@ti.com>
 <20121219212431.GC23594@pratikp-linux.qualcomm.com>
 <50D34EE5.8090407@ti.com>
 <20121220195127.GA14877@pratikp-linux.qualcomm.com>
 <50D3972E.4030607@ti.com>
 <20121221221828.GA2658@pratikp-linux.qualcomm.com>
 <20121223113239.GG16237@mudshark.cambridge.arm.com>
 <20130103180643.GA30277@pratikp-linux.qualcomm.com>
 <20130107115836.GB13542@mudshark.cambridge.arm.com>
 <20130116001458.GB7013@pratikp-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116001458.GB7013@pratikp-linux.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 12:14:59AM +0000, Pratik Patel wrote:
> On Mon, Jan 07, 2013 at 11:58:36AM +0000, Will Deacon wrote:
> > On Thu, Jan 03, 2013 at 06:06:43PM +0000, Pratik Patel wrote:
> > > Whats the advantage in using debugfs here?
> > 
> > The main things I like about debugfs are (a) it's a text-driven interface
> > and easy to script with and (b) it matches what we do for ftrace.
> > 
> > Furthermore, it means that subtle differences between devices can be hidden
> > in the driver and not require different vendor tools for parsing the trace
> > data.
> > 
> Sorry for the delay and maybe I am missing something but it seems
> we can take care of such protocol or parsing/decoding differences
> even with device nodes since that seems independent of the
> interface used - per device debugfs attributes or per device
> device nodes.

You seem to be arguing that the two interfaces are equivalent, in which case
I say that we should follow ftrace's lead and use debugfs for this...

...but I still maintain that debugfs is also far easier to work with from
userspace.

> CoreSight trace solution is typically a SoC wide solution and
> hence can get used by non-Linux processors or hardware. Using
> debugfs would imply compiling it and exposing all the debug
> knobs even if the use case was to use the CoreSight solution for
> something that didn't need all that.

Many debug features require debugfs to be compiled, so I don't buy that as a
show-stopping argument in favour of using dev nodes. I also think that exposing
all of the debug knobs is actually a good thing, given the low-level nature of
coresight devices (where we're offloading most of the knowledge to userspace
anyway).

Will
