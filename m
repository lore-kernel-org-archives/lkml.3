Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3AZDKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 22:10:53 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:35347 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AZDKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 22:10:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130126020535.GA4652@kroah.com>
References: <fe6cef496609.6609fe6cef49@huawei.com> <5102781A.8070502@mvista.com>
 <20130125174442.GA32333@kroah.com> <910F9D9E13B84F4C8FA771DC9BDE99F32702A880@szxeml546-mbx.china.huawei.com>
 <20130126020535.GA4652@kroah.com>
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Date: Fri, 25 Jan 2013 19:10:29 -0800
Message-ID: <CAA6KcBAuHHiGq05ahjF1TDvs0CaqeruBDhff4r8L=AfsKiCB4w@mail.gmail.com>
Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match rules
To: Greg KH <greg@kroah.com>
Cc: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 6:05 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, Jan 26, 2013 at 01:39:50AM +0000, Fangxiaozhi (Franko) wrote:
>>
>>
>> > -----Original Message-----
>> > From: Greg KH [mailto:greg@kroah.com]
>> > Sent: Saturday, January 26, 2013 1:45 AM
>> > To: Fangxiaozhi (Franko)
>> > Cc: Sergei Shtylyov; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
>> > Xueguiying (Zihan); Linlei (Lei Lin); Yili (Neil); Wangyuhua (Roger, Credit);
>> > Huqiao (C); balbi@ti.com; mdharm-usb@one-eyed-alien.net;
>> > sebastian@breakpoint.cc
>> > Subject: Re: [PATCH 1/2]linux-usb:Define a new macro for USB storage match
>> > rules
>> >
>> > On Fri, Jan 25, 2013 at 04:18:34PM +0400, Sergei Shtylyov wrote:
>> > > Hello.
>> > >
>> > > On 25-01-2013 6:44, fangxiaozhi 00110321 wrote:
>> > >
>> > > >From: fangxiaozhi <huananhu@huawei.com>
>> > >
>> > > >1. Define a new macro for USB storage match rules:
>> > > >     matching with Vendor ID and interface descriptors.
>> > >
>> > > >Signed-off-by: fangxiaozhi <huananhu@huawei.com>
>> > > >--------------------------------------------------------------------
>> > > >
>> > > >  diff -uprN linux-3.8-rc4_orig/drivers/usb/storage/usb.c
>> > > >linux-3.8-rc4/drivers/usb/storage/usb.c
>> > > >--- linux-3.8-rc4_orig/drivers/usb/storage/usb.c 2013-01-22
>> > > >14:12:42.595238727 +0800
>> > > >+++ linux-3.8-rc4/drivers/usb/storage/usb.c 2013-01-22
>> > > >+++ 14:16:01.398250305 +0800
>> > > >@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
>> > > >   .useTransport = use_transport, \
>> > > >  }
>> > > >
>> > > >+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
>> > > >+         vendor_name, product_name, use_protocol, use_transport, \
>> > > >+         init_function, Flags) \
>> > > >+{ \
>> > > >+ .vendorName = vendor_name, \
>> > > >+ .productName = product_name, \
>> > > >+ .useProtocol = use_protocol, \
>> > > >+ .useTransport = use_transport, \
>> > > >+ .initFunction = init_function, \
>> > > >+}
>> > >
>> > >   Shouldn't the field initilaizers be indented with tab, not space?
>> >
>> > Yes it must.  fangxiaozhi, please always run your patches through the
>> > scripts/checkpatch.pl tool before sending them out (note, you will have to
>> > ignore the CamelCase warnings your patch produces, but not the other
>> > ones.)
>> >
>> -----What's wrong with it?
>> -----I have checked the patches with scripts/checkpatch.pl before sending.
>> -----There is no other warning or error in my patches except CamelCase warnings.
>> -----So what's wrong now?
>
> Then your email client messed up the patches and put spaces in the code
> instead of tabs.  Try looking at the message on the mailing list and run
> that through checkpatch, it will show you the problems.
>
> What I received isn't ok, sorry.

Fangxiaozhi --

According to the headers of your E-mail, you are using MS Outlook to
send your patches.  Outlook commonly mangles patches, unfortunately.
It is not a very good e-mail client.

I suggest one of two options:

1) Setup an alternative mail client.  There are many to choose from
which will not damage your patches.  I personally like 'mutt' (which
you should be able to install on your linux machine).   Others may be
able to recommend ones that work for them; in general, I think you
will find that most e-mail clients that run on Linux will be suitable.

2) If you plan on contributing to the linux kernel in the future, it
may be worth your time to setup a repo on github that Greg can then
directly pull from.  All you would need to do is send Greg a "pull
request" indicating the URL of the branch in your repo that he should
pull from.  Greg can then pull directly from your repo, bypassing this
issue entirely.

Matt


--
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
