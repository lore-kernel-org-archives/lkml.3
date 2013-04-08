Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936482Ab3DHWDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:03:49 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:57400 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934846Ab3DHWDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:03:47 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: Re: Version number policy!
Date: Tue, 9 Apr 2013 00:03:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc5-wl-wl+; KDE/4.8.4; x86_64; ; )
Cc: Adrian Chadd <adrian@freebsd.org>, Kalle Valo <kvalo@adurom.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "linux-bluetooth" <linux-bluetooth@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "ath9k_htc_fw" <ath9k_htc_fw@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAJ-Vmo=LVSzdEo6DhfOVT_0JHCTMmdPU1zGfMuBmhmr8QuDmJQ@mail.gmail.com> <CAJ-VmomS_=1=QLZrfdD4vhu9Qy0w2JNQxEFrkt_OKjWetrWY4w@mail.gmail.com> <CAFSJ42b7DD9UVtzT7YWhaEchzwpde0yW=pS3nJVeMCHoVQGBqQ@mail.gmail.com>
In-Reply-To: <CAFSJ42b7DD9UVtzT7YWhaEchzwpde0yW=pS3nJVeMCHoVQGBqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304090003.47056.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday, April 08, 2013 10:37:08 PM Eugene Krasnikov wrote:
> Did you have such a situation when e.g. one feature has 2 incompatible
> implementations?
I'm not aware of anything in particular. But we can look elsewhere for
examples, maybe Kalle knows one? Or you could ask the file system folks.
AFAIK ext2 fs is using one and they have maintained some basic 
compatibility throughout the major releases.

For example, it's possible to read data on a ext3 and ext4(dev) file
system with the old ext2 module - this is very user-friendly [1]!
Maybe, you can dig up more examples, just browse the web for "feature 
bits/flags/..."
 
> 2013/4/8 Adrian Chadd <adrian@freebsd.org>:
> > On 8 April 2013 08:33, Christian Lamparter <chunkeey@googlemail.com> wrote:
> >> On Monday, April 08, 2013 11:10:30 AM Eugene Krasnikov wrote:
> >>> It’s a good idea to pack bitmap into the tail/header of the firmware
> >>> binary to get capabilities even before fw loading. The plan is to add
> >>> 8 bytes for caps and also add time stamp. Let me play around with that
> >>> and provide fw and driver patch for review.
> >>
> >> Hm, come to think of it. Kalle, do you think ath9k_htc could use
> >> some bits of the fw header format, parser or the complete infrastructure
> >> from ath6kl? This could be great for Adrian, because he could
> >> just point people to it and they could moved it into the code
> >> into /drivers/net/wireless/ath/fw.c.
> >
> > Just remember that we (ath9k_htc and carl9170) aren't constrained by
> > the same kinds of issues that closed firmware is. So version checks
> > aren't that bad, because that way over time we don't end up needing to
> > maintain lots of special cases for firmware options.

I know, I know, but wouldn't it be great to have a common firmware parsing
infrastructure for all the driver with firmware under ath/? [No, I'm not
talking about writing a firmware that works on all devices. I want common
rules for firmware header descriptors. But if you peg features (firmware
or device!) to abstract firmware versions like "1.2.3.4-34+", then this is
going to be difficult.] 

> > I still like the idea of firmware options for build time options that
> > people may wish to use - eg, say we want to support a version of
> > ath9k-htc firmware that does offloaded TX rate control, versus not.
> > But, maintaining multiple builds of the same firmware is IMHO going to
> > be a path towards madness to maintain.
> >
> > The maintainability is why I'm hoping (!) to keep the number of
> > options low and just do "clean slate" moves whenever we shift to the
> > next major firmware version.

Or like ext2,3,4 => just have a lowest common denominator. So users can
at least always access the web and get a matching firmware. 

Of course, it could be that we are just talking about completely different
things. Anyway, Luis asked me, if I have any "input"... and not more ;-).

Regards,
	Christian

[1] 
<https://ext4.wiki.kernel.org/index.php/Frequently_Asked_Questions#Can_I_mount_existing_Ext3_as_Ext4.3F_And_vice_versa.3F_Similarly_from_Ext2_to_Ext4_and_its_reverse.3F>
