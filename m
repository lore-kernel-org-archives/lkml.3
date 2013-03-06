Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab3CFPph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:45:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab3CFPpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:45:34 -0500
Message-ID: <1362584750.21968.1.camel@dcbw.foobar.com>
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= [PATCH] USB: storage: fix
 Huawei mode switching regression
From: Dan Williams <dcbw@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>,
        "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Date: Wed, 06 Mar 2013 09:45:50 -0600
In-Reply-To: <20130306014424.GA8408@kroah.com>
References: <87obezs888.fsf@nemi.mork.no>
	 <1362403161-23501-1-git-send-email-bjorn@mork.no>
	 <910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com>
	 <8738waqhx2.fsf@nemi.mork.no>
	 <43F99538ECE41341993F359D4AA4FB5F4B3783F2@szxeml560-mbs.china.huawei.com>
	 <20130306014424.GA8408@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 09:44 +0800, Greg KH wrote:
> On Wed, Mar 06, 2013 at 01:34:44AM +0000, Linlei (Lei Lin) wrote:
> > Hello Mork,
> > 
> > >> ------ Because in the embedded linux system, Android, or Chrome OS, 
> > >> etc. They don't integrate userspace usb_modeswitch utility for 
> > >> switching.
> > 
> > >Why not?  If they can upgrade the kernel, then they most certainly can install a userspace utility.
> > 
> > >There is no excuse for an embedded system to do this differently.
> > >Please see e.g. OpenWRT as an example of an embedded system doing this correctly.
> > 
> > But currently Android and Chrome OS has not integrated the
> > usb_modeswitch utility.
> 
> That is not a kernel problem.  I find it hard to believe that Chrome OS
> would not gladly accept code to resolve this issue, can't you put it
> into the modemmanager or whatever Chrome OS uses to handle their
> wireless modems?

They use ModemManager, and that's still not the best place to put
modeswitching.  The best place to modeswitch anything is usb_modeswitch.
No sense duplicating the functionality that usb_modeswitch already
supplies.

Dan

> 
> As for Android, sorry, you are on your own, you will just have to deal
> with the individual OEMs that are incorporating your hardware :(
> 
> > From a vendor's point of view, our purpose is to make our devices be
> > supported natively by those OS.
> 
> We have a solution, usb_modeswitch, any user should be using that.
> 
> > So we consider that add the switch function to the kernel resolves the
> > problem from the source.
> > Then this function will be inherited by Android & Chrome OS.
> 
> Don't circumvent horribly governed userspace projects by getting changes
> into the Linux kernel.  Go fix those projects instead.
> 
> Good luck,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


