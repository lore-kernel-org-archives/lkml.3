Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3AZCEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:04:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:58306 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab3AZCD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:03:58 -0500
Date: Fri, 25 Jan 2013 18:05:35 -0800
From: Greg KH <greg@kroah.com>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
 rules
Message-ID: <20130126020535.GA4652@kroah.com>
References: <fe6cef496609.6609fe6cef49@huawei.com>
 <5102781A.8070502@mvista.com>
 <20130125174442.GA32333@kroah.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F32702A880@szxeml546-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F32702A880@szxeml546-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 01:39:50AM +0000, Fangxiaozhi (Franko) wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Saturday, January 26, 2013 1:45 AM
> > To: Fangxiaozhi (Franko)
> > Cc: Sergei Shtylyov; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Xueguiying (Zihan); Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit);
> > Huqiao (C); balbi@ti.com; mdharm-usb@one-eyed-alien.net;
> > sebastian@breakpoint.cc
> > Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
> > rules
> > 
> > On Fri, Jan 25, 2013 at 04:18:34PM +0400, Sergei Shtylyov wrote:
> > > Hello.
> > >
> > > On 25-01-2013 6:44, fangxiaozhi 00110321 wrote:
> > >
> > > >From: fangxiaozhi <huananhu@huawei.com>
> > >
> > > >1. Define a new macro for USB storage match rules:
> > > >     matching with Vendor ID and interface descriptors.
> > >
> > > >Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> > > >--------------------------------------------------------------------
> > > >
> > > >  diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/usb.c
> > > >linux-3.8-rc4/drivers/usb/storage/usb.c
> > > >--- linux-3.8-rc4_orig/drivers/usb/storage/usb.c 2013-01-22
> > > >14:12:42.595238727 +0800
> > > >+++ linux-3.8-rc4/drivers/usb/storage/usb.c 2013-01-22
> > > >+++ 14:16:01.398250305 +0800
> > > >@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
> > > >   .useTransport = use_transport, \
> > > >  }
> > > >
> > > >+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
> > > >+         vendor_name, product_name, use_protocol, use_transport, \
> > > >+         init_function, Flags) \
> > > >+{ \
> > > >+ .vendorName = vendor_name, \
> > > >+ .productName = product_name, \
> > > >+ .useProtocol = use_protocol, \
> > > >+ .useTransport = use_transport, \
> > > >+ .initFunction = init_function, \
> > > >+}
> > >
> > >   Shouldn't the field initilaizers be indented with tab, not space?
> > 
> > Yes it must.  fangxiaozhi, please always run your patches through the
> > scripts/checkpatch.pl tool before sending them out (note, you will have to
> > ignore the CamelCase warnings your patch produces, but not the other
> > ones.)
> > 
> -----What's wrong with it?
> -----I have checked the patches with scripts/checkpatch.pl before sending.
> -----There is no other warning or error in my patches except CamelCase warnings.
> -----So what's wrong now?

Then your email client messed up the patches and put spaces in the code
instead of tabs.  Try looking at the message on the mailing list and run
that through checkpatch, it will show you the problems.

What I received isn't ok, sorry.

greg k-h
