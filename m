Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3CDXCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:02:37 -0500
Received: from mail.green-internet.de ([213.252.188.14]:36916 "EHLO
	mail.green-internet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758783Ab3CDXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:02:36 -0500
X-Greylist: delayed 2026 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Mar 2013 18:02:35 EST
Message-ID: <5135201F.4030200@draisberghof.de>
Date: Mon, 04 Mar 2013 23:28:47 +0100
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>, zihan@huawei.com,
        Lin.Lei@huawei.com, Greg KH <gregkh@linuxfoundation.org>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua \(Roger\, Credit\)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
References: <87obezs888.fsf@nemi.mork.no> <1362403161-23501-1-git-send-email-bjorn@mork.no> <1362407359.3768.337.camel@deadeye.wl.decadent.org.uk> <878v63ru2i.fsf@nemi.mork.no> <CAA6KcBBdPeS1yEq0SUCzrqSkow1-fCUdp+pfsDX3CWX-uuBGdA@mail.gmail.com> <87wqtnq8bb.fsf@nemi.mork.no>
In-Reply-To: <87wqtnq8bb.fsf@nemi.mork.no>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.03.2013 20:22, schrieb Bjørn Mork:
> Matthew Dharm <mdharm-usb@one-eyed-alien.net> writes:
>> The question is not one of reminding me of what I said earlier....
>> it's one of pointing people in the right direction.  Frankly, some of
>> the fault for this patch lies with Greg and myself for letting it
>> through.  I had just assumed that the Huawei guys had already been in
>> touch with usb-modeswitch for some reason, and that this was just an
>> optimization of existing logic (not an expansion).

I was contacted at one point by a Huawei engineer who convinced me to change the default mode-switching 'message' for all Huawei devices.
The reason was the introduction of an 'advanced' Linux driver by Huawei which requires a specific target mode. This was in October 2010.
No contact attempt since then.

>> Who is maintaining usb-modeswitch these days, anyway?  The comment in
>> the file should point people directly there....

I never ceased work on it and intend to do so for years to come. I would certainly welcome any pointer to the usb_modeswitch main site in the code or the documentation. Although modem developers or engineers should not have a problem finding the site and providing new device information.

>> And, as of now, I would really like to see as many of these devices
>> migrated (albeit slowly) to using usb-modeswitch wherever possible.  I
>> know there are a few devices for which that might not be possible, but
>> I am DONE dealing with this same issue over and over and over again.
>> It will certainly be work to migrate support; maybe we should wrap all
>> the relevant unusual_devs.h entires with
>> CONFIG_UPDATED_MODESWITCH_INSTALLED_SO_MAKE_THESE_GO_AWAY during a
>> transition period?

I think it's safe to say that usb_modeswitch is included in all distributions now. Usually, no user interaction is necessary.

> I guess the real problem will be verifying that all of the entries *can*
> go away. This type of hardware tends to get old very fast, but there is
> always someone having a really ancient device.

I will check this and add any missing USB IDs to usb_modeswitch, but I can't shake the feeling that not *all* Huawei entries in "unusual_devs.h" did actually materialize as devices ...

Anyway, as Bjørn said, putting that initialization into the storage driver takes away quite some possibilities to handle these modems in a flexible way.


Josua Dietze

