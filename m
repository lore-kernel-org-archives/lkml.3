Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3AYRop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:44:45 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60288 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932084Ab3AYRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:44:44 -0500
X-Sasl-enc: gmwq8m+T4JGTgfiiq6VpYvX+2mySayhxPohDIZ3RUtpu 1359135883
Date: Fri, 25 Jan 2013 09:44:42 -0800
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, zihan@huawei.com, Lin.Lei@huawei.com,
        neil.yi@huawei.com, wangyuhua@huawei.com, huqiao36@huawei.com,
        balbi@ti.com, mdharm-usb@one-eyed-alien.net, sebastian@breakpoint.cc
Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
 rules
Message-ID: <20130125174442.GA32333@kroah.com>
References: <fe6cef496609.6609fe6cef49@huawei.com>
 <5102781A.8070502@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5102781A.8070502@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 04:18:34PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 25-01-2013 6:44, fangxiaozhi 00110321 wrote:
> 
> >From: fangxiaozhi <huananhu@huawei.com>
> 
> >1. Define a new macro for USB storage match rules:
> >     matching with Vendor ID and interface descriptors.
> 
> >Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> >--------------------------------------------------------------------
> >
> >  diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/usb.c linux-3.8-rc4/drivers/usb/storage/usb.c
> >--- linux-3.8-rc4_orig/drivers/usb/storage/usb.c 2013-01-22 14:12:42.595238727 +0800
> >+++ linux-3.8-rc4/drivers/usb/storage/usb.c 2013-01-22 14:16:01.398250305 +0800
> >@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
> >   .useTransport = use_transport, \
> >  }
> >
> >+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
> >+         vendor_name, product_name, use_protocol, use_transport, \
> >+         init_function, Flags) \
> >+{ \
> >+ .vendorName = vendor_name, \
> >+ .productName = product_name, \
> >+ .useProtocol = use_protocol, \
> >+ .useTransport = use_transport, \
> >+ .initFunction = init_function, \
> >+}
> 
>   Shouldn't the field initilaizers be indented with tab, not space?

Yes it must.  fangxiaozhi, please always run your patches through the
scripts/checkpatch.pl tool before sending them out (note, you will have
to ignore the CamelCase warnings your patch produces, but not the other
ones.)

Please do that on both of these patches and resend them.

thanks,

greg k-h
