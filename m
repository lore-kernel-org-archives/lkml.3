Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3CGCy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:54:57 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:7304 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3CGCyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:54:55 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Dan Williams <dcbw@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Yili (Neil)" <neil.yi@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: =?utf-8?B?UkU6IOetlOWkjTogW1BBVENIXSBVU0I6IHN0b3JhZ2U6IGZpeCBIdWF3ZWkg?=
 =?utf-8?Q?mode_switching_regression?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIFVTQjogc3RvcmFnZTogZml4IEh1YXdlaSBtb2Rl?=
 =?utf-8?Q?_switching_regression?=
Thread-Index: AQHOGYkwlx41BSLTpUK/JicdprGbMpiXXGAAgAACswCAAOsYAIABPUdQ
Date: Thu, 7 Mar 2013 02:54:38 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F32709E060@szxeml546-mbx.china.huawei.com>
References: <87obezs888.fsf@nemi.mork.no>
	 <1362403161-23501-1-git-send-email-bjorn@mork.no>
	 <910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com>
	 <8738waqhx2.fsf@nemi.mork.no>
	 <43F99538ECE41341993F359D4AA4FB5F4B3783F2@szxeml560-mbs.china.huawei.com>
	 <20130306014424.GA8408@kroah.com> <1362584750.21968.1.camel@dcbw.foobar.com>
In-Reply-To: <1362584750.21968.1.camel@dcbw.foobar.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.145]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r272tHAu018627

Dear Allï¼š
	As far as I know, except switching in kernel, there isn't any mode switch solution on Android now.
	Do you have any good ideas for the mode switch on Android system?
Best Regards,
Franko Fang
> -----Original Message-----
> From: Dan Williams [mailto:dcbw@redhat.com]
> Sent: Wednesday, March 06, 2013 11:46 PM
> To: Greg KH
> Cc: Linlei (Lei Lin); BjÃ¸rn Mork; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; Xueguiying (Zihan); Yili (Neil); Wangyuhua;
> Huqiao (C); balbi@ti.com; mdharm-usb@one-eyed-alien.net;
> sebastian@breakpoint.cc; stable; Fangxiaozhi (Franko)
> Subject: Re: ç­”å¤: [PATCH] USB: storage: fix Huawei mode switching
> regression
> 
> On Wed, 2013-03-06 at 09:44 +0800, Greg KH wrote:
> > On Wed, Mar 06, 2013 at 01:34:44AM +0000, Linlei (Lei Lin) wrote:
> > > Hello Mork,
> > >
> > > >> ------ Because in the embedded linux system, Android, or Chrome
> > > >> OS, etc. They don't integrate userspace usb_modeswitch utility
> > > >> for switching.
> > >
> > > >Why not?  If they can upgrade the kernel, then they most certainly can
> install a userspace utility.
> > >
> > > >There is no excuse for an embedded system to do this differently.
> > > >Please see e.g. OpenWRT as an example of an embedded system doing
> this correctly.
> > >
> > > But currently Android and Chrome OS has not integrated the
> > > usb_modeswitch utility.
> >
> > That is not a kernel problem.  I find it hard to believe that Chrome
> > OS would not gladly accept code to resolve this issue, can't you put
> > it into the modemmanager or whatever Chrome OS uses to handle their
> > wireless modems?
> 
> They use ModemManager, and that's still not the best place to put
> modeswitching.  The best place to modeswitch anything is usb_modeswitch.
> No sense duplicating the functionality that usb_modeswitch already supplies.
> 
> Dan
> 
> >
> > As for Android, sorry, you are on your own, you will just have to deal
> > with the individual OEMs that are incorporating your hardware :(
> >
> > > From a vendor's point of view, our purpose is to make our devices be
> > > supported natively by those OS.
> >
> > We have a solution, usb_modeswitch, any user should be using that.
> >
> > > So we consider that add the switch function to the kernel resolves
> > > the problem from the source.
> > > Then this function will be inherited by Android & Chrome OS.
> >
> > Don't circumvent horribly governed userspace projects by getting
> > changes into the Linux kernel.  Go fix those projects instead.
> >
> > Good luck,
> >
> > greg k-h
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
