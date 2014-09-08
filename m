Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaIHL5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:57:42 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:51184 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaIHL5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:57:41 -0400
Date: Mon, 8 Sep 2014 12:57:35 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 3/4] watchdog: st_wdt: Provide binding documentation for
 ST's LPC Watchdog driver
Message-ID: <20140908115735.GA26284@lee--X1>
References: <1409841592-18890-1-git-send-email-lee.jones@linaro.org>
 <1409841592-18890-5-git-send-email-lee.jones@linaro.org>
 <20140905152758.GA10670@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140905152758.GA10670@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2014, Guenter Roeck wrote:
> On Thu, Sep 04, 2014 at 03:39:51PM +0100, Lee Jones wrote:
> > Signed-off-by: David Paris <david.paris@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> You might want to copy the devicetree mailing list for bindings approval.

This is strange.  There are two emails, exactly the same send 1 second
apart.  Once has the DT ML CC'ed, the other does not.  I think `git
send-email` picked up the *~ file left over by Emacs.  I'll endeavour
to remove those in future.

> > ---
> >  .../devicetree/bindings/watchdog/st-lpc-wdt.txt    | 27 ++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> > new file mode 100644
> > index 0000000..f0e57ba
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/watchdog/st-lpc-wdt.txt
> > @@ -0,0 +1,27 @@
> > +STMicroelectronics LPC Watchdog
> > +===============================
> > +
> > +Required properties
> > +
> > +- compatible 	: "st,<soc>-watchdog"
> 
> Is this acceptable ? I thought the supported bindings have to be listed
> explicitly.

I can do that.

> > +- reg		: LPC registers base address + range
> > +- reg-names	: Register map "base" and "syscfg-en" are compulsory "type" is
> 
> '.' after compulsory ?

Sure. :)

> > +		  platform dependent and not required for the STiH407.
> > +- clock-names 	: Should be "lpc_wdt"
> > +- clocks	: Clock used by LPC device
> > +- timeout-sec	: Qatchdog timeout in seconds
> 
> Watchdog



> > +- st,syscfg	: Syscfg node used to configure cpu reset type and mask
> > +- st,warm_reset	: If present, reset type will be 'warm'. If not, it will be cold
> 
> s/cold/cold./ ?

There shouldn't be any full stops.

Will change s/STiH407./STiH407/ above.

> > +
> > +Example:
> > +	watchdog@fde05000 {
> > +		compatible	= "st,stih416-lpc-watchdog";
> > +		reg		= <0xfde05000 0x1000> <0x204 0x4>;
> > +		reg-names	= "base", "syscfg-en"
> > +		clock-names	= "lpc_wdt";
> > +		clocks 		= <&clk_s_d3_flexgen CLK_LPC_0>;
> > +		timeout-sec	= <600>;
> > +		st,syscfg	= <&syscfg_core>;
> > +		st,warm_reset;
> > +	};
> > +
> 
> Empty line at the end results in a whitespace error when applying.

Will fix.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
