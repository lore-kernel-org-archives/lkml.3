Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3KFBoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:44:21 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43730 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3KFBoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:44:20 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1311051051590.2779@pobox.suse.cz>
References: <20131028150250.755b4cc8@voldemort.scrye.com>
	<CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com>
	<CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
	<5270C549.30201@gmail.com>
	<alpine.LNX.2.00.1311051051590.2779@pobox.suse.cz>
Date: Wed, 6 Nov 2013 09:44:11 +0800
Message-ID: <CAFv23Qkbkh2UGv1fFRApg1nCP5ysvBLnLeSW19JLeAfDmbJEsA@mail.gmail.com>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
From: AceLan Kao <acelan.kao@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nikolai Kondrashov <spbnick@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Kevin Fenzi <kevin@scrye.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, no thoughts about this.
If Kevin would like to try, I can bisect the kernel and build the
Ubuntu .deb package for him.
But like I say above, those 4 commits doesn't look like to lead to the
problem, so I'll try to bisect the whole kernel.

% git bisect start v3.12-rc7 v3.12-rc6
Bisecting: 165 revisions left to test after this (roughly 7 steps)
[edd31476011052d8f6591a3194ba0716b0cea681] bnx2x: Set NETIF_F_HIGHDMA
unconditionally

Best regards,
AceLan Kao.

2013/11/5 Jiri Kosina <jkosina@suse.cz>:
> On Wed, 30 Oct 2013, Nikolai Kondrashov wrote:
>
>> > It's hard to believe that those quirks will lead to the problem.
>> > And actually, there are 4 new commits introduced to -rc7, and 3 of
>> > them are quirks.
>> >
>> > % git log --pretty=oneline v3.12-rc6..v3.12-rc7 drivers/hid
>> > 86b84167d4e67372376a57ea9955c5d53dae232f HID: wiimote: add LEGO-wiimote VID
>> > ad0e669b922c7790182cf19f8015b30e23ad9499 HID: Fix unit exponent parsing
>> > again
>> > 684524d35fe8d13be1f2649633e43bd02c96c695 HID: usbhid: quirk for SiS
>> > Touchscreen
>> > 8171a67d587a09e14a4949a81e070345fedcf410 HID: usbhid: quirk for
>> > Synaptics Large Touchccreen
>> >
>> > CC'd Nikolai, since his commit changes the protocol.
>>
>> My change is very unlikely to produce such problems. It changes calculation of
>> axes resolution at the time the report descriptor is processed. The results of
>> the calculation are not used by the kernel, AFAIK, but only by userspace
>> drivers. The results should not be used to affect the interactions with the
>> device, but only the interpretation of the reports (again, in userspace), and
>> even that is barely done currently.
>>
>> Please try reverting that particular commit and see if it affects the
>> behavior.
>
> AceLan,
>
> do you have any update, please?
>
> --
> Jiri Kosina
> SUSE Labs
