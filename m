Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3E3PCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:02:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52202 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3E3PCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:02:38 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 May 2013 08:03:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: xilinx: Add WDIOC_SETTIMEOUT ioctl function
Message-ID: <20130530150306.GA29508@roeck-us.net>
References: <b565740967bfa3b3fa867442634f524000c097f8.1369916757.git.michal.simek@xilinx.com>
 <595eb49b34909318959fe6825c209a7d635ed849.1369916757.git.michal.simek@xilinx.com>
 <20130530140754.GB28232@roeck-us.net>
 <51A75F11.7000001@monstr.eu>
 <20130530142145.GA28856@roeck-us.net>
 <51A7635A.8070300@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A7635A.8070300@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 04:34:02PM +0200, Michal Simek wrote:
> On 05/30/2013 04:21 PM, Guenter Roeck wrote:
> > On Thu, May 30, 2013 at 04:15:45PM +0200, Michal Simek wrote:
> >> On 05/30/2013 04:07 PM, Guenter Roeck wrote:
> >>> On Thu, May 30, 2013 at 02:26:04PM +0200, Michal Simek wrote:
> >>>> Standard watchdog programs try to setup timeout
> >>>> via ioctl and this functionality should be implemented.
> >>>> Timeout value is hardcoded in the hardware but
> >>>> based on Documentation/watchdog/watchdog-api.txt
> >>>> can return the real timeout used in the same variable.
> >>>>
> >>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> >>>> ---
> >>>>  drivers/watchdog/of_xilinx_wdt.c | 1 +
> >>>>  1 file changed, 1 insertion(+)
> >>>>
> >>>> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
> >>>> index 79f358c..a3bbe72 100644
> >>>> --- a/drivers/watchdog/of_xilinx_wdt.c
> >>>> +++ b/drivers/watchdog/of_xilinx_wdt.c
> >>>> @@ -253,6 +253,7 @@ static long xwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >>>>  		xwdt_keepalive();
> >>>>  		return 0;
> >>>>
> >>>> +	case WDIOC_SETTIMEOUT:
> >>>>  	case WDIOC_GETTIMEOUT:
> >>>>  		if (no_timeout)
> >>>>  			return -ENOTTY;
> >>>
> >>> Watchdog programs should check ident.options before trying to set the timeout.
> >>> If they don't, there is an application bug. I don't think it is a good idea
> >>> to start hacking the kernel to work around application bugs.
> >>
> >> Based on Documentation/watchdog/watchdog-api.txt
> >>
> >> "For some drivers it is possible to modify the watchdog timeout on the
> >> fly with the SETTIMEOUT ioctl, those drivers have the WDIOF_SETTIMEOUT
> >> flag set in their option field.  The argument is an integer
> > 
> > Yes, but WDIOF_SETTIMEOUT is not set in the driver's option field.
> 
> ok. It means I should probably enable it.
> 
I am missing your point. Applications should not try to write the timeout
since WDIOF_SETTIMEOUT is not set. Any application doing it anyway is buggy
and should be fixed.

Guenter
