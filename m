Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3BVXJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:09:10 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60995 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3BVXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:09:07 -0500
MIME-Version: 1.0
In-Reply-To: <5127CC40.6070507@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
	<1361555907-19840-12-git-send-email-nick.dyer@itdev.co.uk>
	<CANLzEkusmqAFSybWd+xbLYbUu+5rcih7AW024eCpZ7AFb-+UCw@mail.gmail.com>
	<5127CC40.6070507@itdev.co.uk>
Date: Fri, 22 Feb 2013 15:09:06 -0800
X-Google-Sender-Auth: M3W-RGd2EN34j58w79A5eAwuO74
Message-ID: <CANLzEkuNBRUB9gUdFDJgeBn-GpK95XCA-RsCSKTdOv2hEFTjRA@mail.gmail.com>
Subject: Re: [PATCH 11/40] Input: atmel_mxt_ts - Bootloader addresses for mXT1664/mXT1188S
From: Benson Leung <bleung@chromium.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've moved away from using platform data in our project because it's
clunky, and because we implemented the config loading that's similar
to what you submitted elsewhere in this series.

Furthermore, for our ARM projects specifically, we are using flattened
device trees to describe our board and instantiate devices. The upside
is that it means that we no longer have to modify the kernel to bring
up a new board with some varied hardware.

The downside is that it's impossible to setup platform data for i2c
devices from the device tree. drivers/of/of_i2c.c instantiates i2c
devices including the atmel touch device, and it doesn't and shouldn't
know about how atmel_mxt_ts's platform data is structured. All it does
is i2c_new_device on the right adapter, at the right address, and
optionally pass in an irq #.



On Fri, Feb 22, 2013 at 11:51 AM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> Benson Leung wrote:
>> This is disappointing that Atmel decided to change the bootloader
>> address scheme for the 1664S family. Unfortunately, this ifdef won't
>> work for situations where there are more than one Atmel device of a
>> different kind on a system using this same driver.
>>
>> For the Chromebook Pixel, we use the same atmel_mxt_ts driver for a
>> 1664S device and a 224SL.
>>
>> The 1664S has the pair 0x26 and 0x4a, while the 224SL has 0x25 and
>> 0x4b.
>
> If I put a bootloader address override in the platform data will that meet
> your requirements?



--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
