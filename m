Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaDFU4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:56:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaDFU4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:56:44 -0400
Date: Sun, 6 Apr 2014 13:59:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: devel@driverdev.osuosl.org, Silvan Jegen <s.jegen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: rtl8192e: Fix sparse warning
Message-ID: <20140406205913.GA19577@kroah.com>
References: <5341A05A.5080403@gmail.com>
 <20140406190145.GB30469@kroah.com>
 <5341A72C.6050408@gmail.com>
 <20140406202657.GA13178@kroah.com>
 <5341BC7E.3060007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5341BC7E.3060007@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 03:43:42PM -0500, Joel Pelaez Jorge wrote:
> El 06/04/14 15:26, Greg Kroah-Hartman escribió:
> > On Sun, Apr 06, 2014 at 02:12:44PM -0500, Joel Pelaez Jorge wrote:
> >> El 06/04/14 14:01, Greg Kroah-Hartman escribió:
> >>> On Sun, Apr 06, 2014 at 01:43:38PM -0500, Joel Pelaez Jorge wrote:
> >>>> Fix a sparse warning, non static symbol is no declared as such.
> >>>> And fix a conflict with static function declared extern to include
> >>>> rtl_wx.h header.
> >>>>
> >>>> drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323:24: warning:
> >>>> symbol 'r8192_wx_handlers_def' was not declared. Should it be static?
> >>>>
> >>>> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
> >>>> ---
> >>>>     drivers/staging/rtl8192e/rtl8192e/rtl_wx.c |    3 ++-
> >>>>     1 file changed, 2 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> >>>> b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> >>>> index 498995d..f17584d 100644
> >>>> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> >>>> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> >>>> @@ -19,6 +19,7 @@
> >>>>
> >>>>     #include <linux/string.h>
> >>>>     #include "rtl_core.h"
> >>>> +#include "rtl_wx.h"
> >>>
> >>> Why is this needed?
> >>>
> >>>>
> >>>>     #define RATE_COUNT 12
> >>>>     static u32 rtl8192_rates[] = {
> >>>> @@ -1293,7 +1294,7 @@ static iw_handler r8192_private_handler[] = {
> >>>>     	(iw_handler)r8192_wx_get_PromiscuousMode,
> >>>>     };
> >>>>
> >>>> -static struct iw_statistics *r8192_get_wireless_stats(struct net_device
> >>>> *dev)
> >>>> +struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
> >>>
> >>> Why make this global?  This doesn't have anything to do with the warning
> >>> you are working on as described above.
> >>>
> >>> totally confused,
> >>>
> >>> greg k-h
> >>>
> >>   >
> >> In the "rtl_wx.h" header declare extern 'r8192_wx_handlers_def'
> >> but r8192_get_wireless_stats too.
> > 
> > I don't understand what this sentance means :(
> > 
> >> Because r8192_get_wireless_stats is used by rtl_core.h if WIRELESS_EXT
> >> is more that 12 but less that 17.
> > 
> > Will that value ever change?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> The file: 'rtl_wx.h' is a header that defines some symbols uses
> externally by 'rtl_core.c', it declare:
> 
> extern struct iw_handler_def r8192_wx_handlers_def;
> struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev);
> 
> If this header is included in rtl_wx.c, fix the sparse warning, but
> cause conflict with the function declaration, because in 'rtl_wx.c'
> r8192_get_wireless_stats is defined as 'static'.
> 
> In the header is defined as 'extern' because is called by rtl_core.c
> if the WIRELESS_EXT certain values.

Ok, that makes more sense.  Can you put all of that in the changelog
entry and resend the patch?

> By the way, WIRELESS_EXT is a define constant that indicate the
> wireless extension version supported by the kernel it only up.
> The better solution is remove the code that called the function, remove
> the declaration and only keep 'r8192_wx_handlers_def'.

That would be best...

thanks,

greg k-h
