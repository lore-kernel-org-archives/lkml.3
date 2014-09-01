Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaIAWQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:16:18 -0400
Received: from senator.holtmann.net ([87.106.208.187]:48357 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaIAWQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:16:17 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: patch "staging: remove nokia_hp4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140831095147.GB24601@amd>
Date: Mon, 1 Sep 2014 15:16:28 -0700
Cc: Greg KH <gregkh@linuxfoundation.org>, Miguel Oliveira <cmroliv@gmail.com>,
        =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4CA4FD0A-C167-4A12-A137-766CB3A2D5D5@holtmann.org>
References: <14094295422869@kroah.com> <20140830213022.GA17147@amd> <20140830220417.GA15000@kroah.com> <20140830224430.GA19622@amd> <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org> <20140831095147.GB24601@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>>>> What is going on here? I get flamed for not cleaning up the driver,
>>>>> because I cleaned it up before merging to -staging. Ok, so I did more
>>>>> cleanups, sent 3 cleanup patches, no reaction on those, and now I got
>>>>> a note that you are going to remove the driver...?
>>>> 
>>>> For the 3 "cleanup" patches, the first one was rejected and you said to
>>>> not include it, so I couldn't apply the others.
>>> 
>>> That was different series. I'm talking about:
>>> 
>>> [PATCH 1/3] staging: nokia_h4: switch to right types and use bdaddr_t
>>> [PATCH 2/3] staging: nokia_h4: avoid __uX types
>>> [PATCH 3/3] staging: use inlines where it makes sense
>>> 
>>> That is still valid and received no comments at all.
> 
>> and these are all trivial cleanups and could have been done back in
>> January when this driver was merged into staging. It is end of
>> August now and nothing happened to address anything in the TODO
>> file.
> 
> [Could you please wrap at 80 characters?]
> 
> Would be done in january if someone pointed the problems out.
> 
> For the record, 3/3 addresses your comment
> 
> "These are a lot of public functions. Are they all really needed or can
> the code be done smart."
> 
> in TODO file.

so what about all the other really major details that needed fixing. I mean anybody who was compiling for OMAP platform could have fixed the tons and tons of inlines quickly.

>> The warning from end of May that this driver will be removed seemed
>> to not have triggered anybody to work on the core issues of the
>> driver.
> 
> Actually it did trigger me to work on the patch series above. It is
> just that the series was ignored, and now I'm told that driver is
> going to be removed because I did not do the work.

The driver got removed, because nobody started the real work to make it an upstream driver.

>> There are 3 major topics that needs addressing before this driver should come anywhere near upstream kernel again, staging or otherwise.
>> 
>> a) Convert to using device tree for device detection
>> 
>> b) Convert to using hdev->setup for firmware loading
>> 
>> c) Convert to using hdev->set_bdaddr and HCI_QUIRK_INVALID_BDADDR
> 
> I thought staging is for merging code to be cleaned up. Not "please
> rewrite, and possibly break the driver before merging it into
> staging". Merge it into staging, then clean it up there.

The staging tree is for drivers to eventually go upstream. Staging is not a long term solution for a driver. It never was and never will be. So cleanup means whatever is required to get it upstream. And that means that you need to rewrite pieces.

For example a WiFi driver that ships its own 802.11 stack will never get upstream unless you re-write it to use mac80211.

> (Also hopefully get some testing from n900 community; code is more
> visible in staging).

The problem is that they are testing the wrong thing. And lets face it, we already knew this driver works since Nokia shipped it in products.

> And BTW it is first time I hear about a).

So the whole ARM community is moving over to DT and you are ignoring it. I complained about the platform data before. Someone told me that the N900 will be converted to DT. So I assume that this driver will also use DT then. If that was not clear, then now I made it clear.

>> Please keep in mind that this was not an ugly Windows driver with a
>> lot of Windows specific typedefs or bad coding style or OS
>> abstractions. From that point of view it was always good since it
>> was written for Linux in the first place. It was just a bit
>> dated. Any fixes to bring that in sync with all other drivers could
>> have been done easily after it was merged into the Bluetooth
>> subsystem.
> 
> So you are saying that most of the comments you had when I attempted
> to merge the driver did not really need to be addressed? That's news
> to me, normally maintainers want their comments addressed.

All the coding style and cleanups like moving code around could have been done with a few days. So if the 3 major items would have been fixed, then getting the driver into shape is dead simple.

> And yes, this driver bitroted a lot while being out of tree. It was
> probably pretty good initially, mergeable with minimum effort. Now you
> want it to bitrot a bit more.

Back in the days it was hard to merge since most of the OMAP stuff it depends on was not upstream. That why it never made it there. In addition that you need to build for specific OMAP boards makes it really hard to just take the driver. If it would have compiled on x86, I bet it would already been upstream.

>> The reason why it ended up in staging is that the 3 core problems needed fixing. And 8 month later they still have not been fixed.
>> 
> 
> I attempted hdev->setup conversion, but could not figure it out till
> now. Clearly it needs to be done.
> 
> For doing that, it would be good to have userland to work with, and
> yes it takes time. (Debugging on 4" screen sucks.)

Actually hdev->setup does not need any userland. As long as request_firmware() works, you are just fine. And since the driver already uses that in the first place, I assume it works.

The Nokia firmware files have been sequences of HCI commands since forever. And I pointed you towards __hci_cmd_sync early on. And we have good examples of that in use already.

>>> You asked for more work and explained how easy it is to revert the
>>> removal.
>>> 
>>> I did more work, you ignored it, and are removing the driver, anyway.
>> 
>> I have seen only fluff patches. Someone needs to address the core problems of the driver.
> 
> Clearly. But at the same time not taking even the trivial patches is
> great way of stalling the devopment.

I do not maintain staging. However in this specific case there were pretty clear instructions on what needed changing. You can check for yourself on how much got addressed.

Regards

Marcel

