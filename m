Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3J3Ihk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:37:40 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38318 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3J3Ihf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:37:35 -0400
Message-ID: <5270C549.30201@gmail.com>
Date: Wed, 30 Oct 2013 10:37:29 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: AceLan Kao <acelan.kao@canonical.com>
CC: Josh Boyer <jwboyer@fedoraproject.org>, Kevin Fenzi <kevin@scrye.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
References: <20131028150250.755b4cc8@voldemort.scrye.com> <CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com> <CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
In-Reply-To: <CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi AceLan,

On 10/30/2013 03:41 AM, AceLan Kao wrote:
> It's hard to believe that those quirks will lead to the problem.
> And actually, there are 4 new commits introduced to -rc7, and 3 of
> them are quirks.
>
> % git log --pretty=oneline v3.12-rc6..v3.12-rc7 drivers/hid
> 86b84167d4e67372376a57ea9955c5d53dae232f HID: wiimote: add LEGO-wiimote VID
> ad0e669b922c7790182cf19f8015b30e23ad9499 HID: Fix unit exponent parsing again
> 684524d35fe8d13be1f2649633e43bd02c96c695 HID: usbhid: quirk for SiS Touchscreen
> 8171a67d587a09e14a4949a81e070345fedcf410 HID: usbhid: quirk for
> Synaptics Large Touchccreen
>
> CC'd Nikolai, since his commit changes the protocol.

My change is very unlikely to produce such problems. It changes calculation of
axes resolution at the time the report descriptor is processed. The results of
the calculation are not used by the kernel, AFAIK, but only by userspace
drivers. The results should not be used to affect the interactions with the
device, but only the interpretation of the reports (again, in userspace), and
even that is barely done currently.

Please try reverting that particular commit and see if it affects the
behavior.

Sincerely,
Nick
