Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3CDTWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:22:53 -0500
Received: from canardo.mork.no ([148.122.252.1]:48947 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738Ab3CDTWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:22:50 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fangxiaozhi \(Franko\)" <fangxiaozhi@huawei.com>, zihan@huawei.com,
        Lin.Lei@huawei.com, Greg KH <gregkh@linuxfoundation.org>,
        "Yili \(Neil\)" <neil.yi@huawei.com>,
        "Wangyuhua \(Roger\, Credit\)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>,
        Josua Dietze <digidietze@draisberghof.de>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
Organization: m
References: <87obezs888.fsf@nemi.mork.no>
	<1362403161-23501-1-git-send-email-bjorn@mork.no>
	<1362407359.3768.337.camel@deadeye.wl.decadent.org.uk>
	<878v63ru2i.fsf@nemi.mork.no>
	<CAA6KcBBdPeS1yEq0SUCzrqSkow1-fCUdp+pfsDX3CWX-uuBGdA@mail.gmail.com>
Date: Mon, 04 Mar 2013 20:22:16 +0100
In-Reply-To: <CAA6KcBBdPeS1yEq0SUCzrqSkow1-fCUdp+pfsDX3CWX-uuBGdA@mail.gmail.com>
	(Matthew Dharm's message of "Mon, 4 Mar 2013 08:59:10 -0800")
Message-ID: <87wqtnq8bb.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm <mdharm-usb@one-eyed-alien.net> writes:

> Frankly, I consider it appropriate.

OK, I'll try to cook something up.

> The question is not one of reminding me of what I said earlier....
> it's one of pointing people in the right direction.  Frankly, some of
> the fault for this patch lies with Greg and myself for letting it
> through.  I had just assumed that the Huawei guys had already been in
> touch with usb-modeswitch for some reason, and that this was just an
> optimization of existing logic (not an expansion).  And, frankly, I
> was just a bit tired of fighting this fight over and over again;
> having something in the file which says "here's the right and official
> way to do this" would be good.
>
> I also asked the Huawei guys about the possibility of affecting other
> devices than the one listed.... I guess one of us either wasn't clear
> or mis-understood the request.  The fact that there are devices out
> there failing now illustrates that.  Avoiding breaking existing
> systems is one of the highest priorities....

Well, I am a bit embarrassed by this.  I did notice the patch and even
looked through it when it was posted.  But when I later noticed the
switching failure I didn't think more about it at all.  I just put the
error on my to-be-investigated-further list.  Which tends to erase
itself before I get to it...

> Who is maintaining usb-modeswitch these days, anyway?  The comment in
> the file should point people directly there....

That would be Josua Dietze, who I intended to CC from the beginning of
this discussion but forgot...  Sorry about that.  I'm certainly not
going to complain about anyone else forgetting stuff :)

CCed now. Josh, I assume it's OK for you if we put a pointer to
http://www.draisberghof.de/usb_modeswitch/ in the unusual_devs.h code? 

> And, as of now, I would really like to see as many of these devices
> migrated (albeit slowly) to using usb-modeswitch wherever possible.  I
> know there are a few devices for which that might not be possible, but
> I am DONE dealing with this same issue over and over and over again.
> It will certainly be work to migrate support; maybe we should wrap all
> the relevant unusual_devs.h entires with
> CONFIG_UPDATED_MODESWITCH_INSTALLED_SO_MAKE_THESE_GO_AWAY during a
> transition period?

Sounds good to me, if that is acceptable to the user interface stability
committee.

I guess the real problem will be verifying that all of the entries *can*
go away. This type of hardware tends to get old very fast, but there is
always someone having a really ancient device.

Maybe we could use the same method the netdev people use when they want
to remove stuff: Subtly break it and leave it like that for a few years
before finally deleting it, arguing that noone can be using the feature
because it's broken :)


Bjørn

> On Mon, Mar 4, 2013 at 8:47 AM, Bjørn Mork <bjorn@mork.no> wrote:
>> Ben Hutchings <ben@decadent.org.uk> writes:
>>> On Mon, 2013-03-04 at 14:19 +0100, Bjørn Mork wrote:
>>> [...]
>>>> In-kernel mode switching was deprecated years ago with the
>>>> development of the more user friendly userspace alternatives. The
>>>> existing list of devices in usb-storage was only kept to prevent
>>>> breaking already working systems.  The long term plan is to remove
>>>> the list, not to add to it. Ref:
>>>> http://permalink.gmane.org/gmane.linux.usb.general/28543
>>> [...]
>>>
>>> Can you add a comment to this effect?
>>
>> In the table in unusual_devs.h, you mean?  Sure, I can do that.
>>
>> But it feels a bit strange since I can only quote and/or refer to what
>> Matthew and Greg said about the issue years ago.  Putting a comment in
>> the code to remind the current maintainers about their own statements
>> could be considered out of line?  Or is this appropriate here?
>>
>>
>> Bjørn
>
>
>
> --
> Matthew Dharm
> Maintainer, USB Mass Storage driver for Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
