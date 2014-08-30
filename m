Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaH3XI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 19:08:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34288 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaH3XIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 19:08:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: patch "staging: remove nokia_hp4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140830224430.GA19622@amd>
Date: Sat, 30 Aug 2014 16:09:01 -0700
Cc: Greg KH <gregkh@linuxfoundation.org>, Miguel Oliveira <cmroliv@gmail.com>,
        =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org>
References: <14094295422869@kroah.com> <20140830213022.GA17147@amd> <20140830220417.GA15000@kroah.com> <20140830224430.GA19622@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> What is going on here? I get flamed for not cleaning up the driver,
>>> because I cleaned it up before merging to -staging. Ok, so I did more
>>> cleanups, sent 3 cleanup patches, no reaction on those, and now I got
>>> a note that you are going to remove the driver...?
>> 
>> For the 3 "cleanup" patches, the first one was rejected and you said to
>> not include it, so I couldn't apply the others.
> 
> That was different series. I'm talking about:
> 
> [PATCH 1/3] staging: nokia_h4: switch to right types and use bdaddr_t
> [PATCH 2/3] staging: nokia_h4: avoid __uX types
> [PATCH 3/3] staging: use inlines where it makes sense
> 
> That is still valid and received no comments at all.

and these are all trivial cleanups and could have been done back in January when this driver was merged into staging. It is end of August now and nothing happened to address anything in the TODO file.

The warning from end of May that this driver will be removed seemed to not have triggered anybody to work on the core issues of the driver.

There are 3 major topics that needs addressing before this driver should come anywhere near upstream kernel again, staging or otherwise.

a) Convert to using device tree for device detection

b) Convert to using hdev->setup for firmware loading

c) Convert to using hdev->set_bdaddr and HCI_QUIRK_INVALID_BDADDR

Please keep in mind that this was not an ugly Windows driver with a lot of Windows specific typedefs or bad coding style or OS abstractions. From that point of view it was always good since it was written for Linux in the first place. It was just a bit dated. Any fixes to bring that in sync with all other drivers could have been done easily after it was merged into the Bluetooth subsystem.

The reason why it ended up in staging is that the 3 core problems needed fixing. And 8 month later they still have not been fixed.

>>> Please don't, I'd still like to clean the driver up and get included,
>>> as n900's are still under active use.
>> 
>> As the Bluetooth maintainer has said a number of times, he doesn't want
>> the driver in the tree as it is not doing the correct things.  It's been
>> a long time in the tree with no work on it at all, and I follow the
>> suggestions of the maintainers of the subsystems that staging drivers
>> follow.
> 
> You asked for more work and explained how easy it is to revert the
> removal.
> 
> I did more work, you ignored it, and are removing the driver, anyway.

I have seen only fluff patches. Someone needs to address the core problems of the driver.

>> I suggest cleaning this up  in your own tree, and then just submitting it
>> for inclusion in the "normal" part of the kernel.  That way I'm not
> 
> ...creating a mess in the history, and fun merge problems for
> people actually using the driver :-(. And yes, n900 people actually
> are using it and have their own changes on top of it.

That is even worse. We have a staging driver with external patches on top of it. Getting a driver into staging has an almost zero barrier and then people still not get their patches merged into staging. That is just plain said.

Regards

Marcel

