Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3HKTyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 15:54:54 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52367 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3HKTyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 15:54:51 -0400
MIME-Version: 1.0
In-Reply-To: <CANLzEkvi7PY7iO+kicCQZaSi7n6mn2JUC3hVVvPJN2LcCLnqKw@mail.gmail.com>
References: <1374163091-4750-1-git-send-email-enselic@gmail.com>
	<CANLzEksSsMY2pTYTfGzgntF-i_Kus+WeVPyNzW0U7APcGOv_5g@mail.gmail.com>
	<CAC-DJzL0VzDxCpsdwjugavBhcFUr+kv+iN9D-Yz_tasw=DF75Q@mail.gmail.com>
	<CANLzEkvi7PY7iO+kicCQZaSi7n6mn2JUC3hVVvPJN2LcCLnqKw@mail.gmail.com>
Date: Sun, 11 Aug 2013 21:54:50 +0200
Message-ID: <CAC-DJz+Q=O9hvj1QoaZkhSZ-e6ueUQHUuMntin=GYdLqwV0VtA@mail.gmail.com>
Subject: Re: [PATCH 0/1] Platform: x86: chromeos_laptop - convert to
 i2c_driver to handle i915 race
From: Martin Nordholts <enselic@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Olof Johansson <olof@lixom.net>, Yufeng Shen <miletus@chromium.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/7 Benson Leung <bleung@chromium.org>
>
> If you get a chance, could you let me know if my deferred probe
> changes work well in your configuration?

I can confirm that your changes works, i.e. the touchpad and
touchscreen works directly after boot on my 32GB non-LTE Chromebook
Pixel. I applied the patches on a clean 3.11-rc4 tree using a
localmodconfig on Debian 7.1. I get this in dmesg --level err
(--notime) though

find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus vga not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus vga not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus vga not found on system.
find_i2c_adapter_num: i2c adapter i915 gmbus panel not found on system.

Personally I don't like getting error messages when the driver works
as designed. I would prefer to have priority lowered to 'notice' on
those.

Regards,
Martin
