Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3CDQ7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:59:34 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:53876 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab3CDQ7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:59:32 -0500
MIME-Version: 1.0
In-Reply-To: <878v63ru2i.fsf@nemi.mork.no>
References: <87obezs888.fsf@nemi.mork.no> <1362403161-23501-1-git-send-email-bjorn@mork.no>
 <1362407359.3768.337.camel@deadeye.wl.decadent.org.uk> <878v63ru2i.fsf@nemi.mork.no>
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Date: Mon, 4 Mar 2013 08:59:10 -0800
Message-ID: <CAA6KcBBdPeS1yEq0SUCzrqSkow1-fCUdp+pfsDX3CWX-uuBGdA@mail.gmail.com>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>, zihan@huawei.com,
        Lin.Lei@huawei.com, Greg KH <gregkh@linuxfoundation.org>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frankly, I consider it appropriate.

The question is not one of reminding me of what I said earlier....
it's one of pointing people in the right direction.  Frankly, some of
the fault for this patch lies with Greg and myself for letting it
through.  I had just assumed that the Huawei guys had already been in
touch with usb-modeswitch for some reason, and that this was just an
optimization of existing logic (not an expansion).  And, frankly, I
was just a bit tired of fighting this fight over and over again;
having something in the file which says "here's the right and official
way to do this" would be good.

I also asked the Huawei guys about the possibility of affecting other
devices than the one listed.... I guess one of us either wasn't clear
or mis-understood the request.  The fact that there are devices out
there failing now illustrates that.  Avoiding breaking existing
systems is one of the highest priorities....

Who is maintaining usb-modeswitch these days, anyway?  The comment in
the file should point people directly there....

And, as of now, I would really like to see as many of these devices
migrated (albeit slowly) to using usb-modeswitch wherever possible.  I
know there are a few devices for which that might not be possible, but
I am DONE dealing with this same issue over and over and over again.
It will certainly be work to migrate support; maybe we should wrap all
the relevant unusual_devs.h entires with
CONFIG_UPDATED_MODESWITCH_INSTALLED_SO_MAKE_THESE_GO_AWAY during a
transition period?

Matt



On Mon, Mar 4, 2013 at 8:47 AM, Bjørn Mork <bjorn@mork.no> wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>> On Mon, 2013-03-04 at 14:19 +0100, Bjørn Mork wrote:
>> [...]
>>> In-kernel mode switching was deprecated years ago with the
>>> development of the more user friendly userspace alternatives. The
>>> existing list of devices in usb-storage was only kept to prevent
>>> breaking already working systems.  The long term plan is to remove
>>> the list, not to add to it. Ref:
>>> http://permalink.gmane.org/gmane.linux.usb.general/28543
>> [...]
>>
>> Can you add a comment to this effect?
>
> In the table in unusual_devs.h, you mean?  Sure, I can do that.
>
> But it feels a bit strange since I can only quote and/or refer to what
> Matthew and Greg said about the issue years ago.  Putting a comment in
> the code to remind the current maintainers about their own statements
> could be considered out of line?  Or is this appropriate here?
>
>
> Bjørn



--
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
