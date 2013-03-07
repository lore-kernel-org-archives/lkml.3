Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab3CGMUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:20:25 -0500
Received: from canardo.mork.no ([148.122.252.1]:33393 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab3CGMUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:20:23 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Fangxiaozhi \(Franko\)" <fangxiaozhi@huawei.com>
Cc: Dan Williams <dcbw@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        "Linlei \(Lei Lin\)" <lei.lin@huawei.com>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying \(Zihan\)" <zihan.xue@huawei.com>,
        "Yili \(Neil\)" <neil.yi@huawei.com>,
        Wangyuhua <yuhua.wang@huawei.com>,
        "Huqiao \(C\)" <huqiao36@huawei.com>, "balbi\@ti.com" <balbi@ti.com>,
        "mdharm-usb\@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian\@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>,
        Josua Dietze <digidietze@draisberghof.de>
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH] USB: storage: fix Huawei mode
 switching regression
Organization: m
References: <87obezs888.fsf@nemi.mork.no>
	<1362403161-23501-1-git-send-email-bjorn@mork.no>
	<910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com>
	<8738waqhx2.fsf@nemi.mork.no>
	<43F99538ECE41341993F359D4AA4FB5F4B3783F2@szxeml560-mbs.china.huawei.com>
	<20130306014424.GA8408@kroah.com>
	<1362584750.21968.1.camel@dcbw.foobar.com>
	<910F9D9E13B84F4C8FA771DC9BDE99F32709E060@szxeml546-mbx.china.huawei.com>
Date: Thu, 07 Mar 2013 13:19:26 +0100
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F32709E060@szxeml546-mbx.china.huawei.com>
	(fangxiaozhi@huawei.com's message of "Thu, 7 Mar 2013 02:54:38 +0000")
Message-ID: <87haknjtbl.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> writes:

> 	As far as I know, except switching in kernel, there isn't any
> 	mode switch solution on Android now.  Do you have any good ideas
> 	for the mode switch on Android system?

Josh, the usb_modeswitch maintainer, is also maintaining this Android app:
http://www.draisberghof.de/android/pppwidget.html

That's one possible solution.   According to him, there is also

 "a number of Chinese Android tablets (from the A10 family) that are
  supporting a number of 3G modem sticks by providing usb_modeswitch
  on-board, which is obviously working well."

That's another possible solution.

Userspace mode switching on Android should not be any more difficult
than userspace mode switching on any other Linux distro. You unbind the
usb-storage driver and submit your bulk message.  Looking at a sample
Android device (Galaxy S3 running the default image):

 shell@android:/ $ cat /proc/version                                            
 Linux version 3.0.31-836582 (se.infra@SEP-97) (gcc version 4.4.3 (GCC) ) #1 SMP PREEMPT Tue Jan 15 14:17:21 KST 2013
 shell@android:/ $ ls -l /dev/bus/usb/001/                                      
 crw-rw---- root     usb      189,   0 2013-02-19 19:51 001
 crw-rw---- root     usb      189,   2 2013-03-07 09:01 003

it looks like your app will need to be a member of the "usb" group to do
this.  I assume there is a way for an app to request such permissions in
Android.  Josh has obviously managed to get it.


Bjørn
