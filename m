Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3KNPct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:32:49 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52081 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3KNPcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:32:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
References: <20131113183418.GA1593@thinkpad.fritz.box>
	<20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
Date: Thu, 14 Nov 2013 16:32:41 +0100
Message-ID: <CAMeQTsYuP-zMMJS3kLveDf=TWa7SnWVLkS=TFXjP8A-vZ8-nXQ@mail.gmail.com>
Subject: Re: Black screen with GMA500 driver on Atom E680 (invalid VBT signature)
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andreas Werner <wernerandy@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 2:52 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> My question now is, is it a bug in the driver or in the VGA Bios?
>>
>> I´ve checked the VGA bios and did a hex dump but there is really no "$VBT" string.
>> On an Atom Gen1 CPU with intel GMA500 Graphic there is the string in the VGA BIOS.
>> But if i create the VGA BIOS for intel Atom E680 which has a GMA600 Graphic
>> there is no string.
>>
>> Does anybody of you running the GMA500 driver with and Atom E680 without having this
>> problem? Or does anybody know how to get this string into the VGA BIOS?
>
> E680 I believe will try and use the other style of parsing. I never got
> my hands on one to confirm that but in general E6xx seems to use
> Moorestown style tables instead and you'll only get support for some
> outputs.

As Alan says, Moorestown should use GCT as in mid_bios.c and the signature
should be $GCT instead of $VBT. Though I don't know if you get any LVDS info
from from that or just MIPI stuff.

In my last set of patches I included 0x4108 in the IS_MRST macro which might
make gma500 find the LVDS modes via I2C. In the same patchset there is also
support for SDVO on Moorestown.

Patches are available in Dave Airlies drm-next and heading for 3.13-rc1

Thanks
Patrik
