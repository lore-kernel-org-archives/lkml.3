Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3LNQ01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 11:26:27 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44177 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3LNQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 11:26:26 -0500
MIME-Version: 1.0
In-Reply-To: <52AC7E41.7050201@roeck-us.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
	<1386945188-8316-2-git-send-email-jonas.jensen@gmail.com>
	<201312131717.25435.arnd@arndb.de>
	<CACmBeS0Uz+Z=MsqvXburO1swCdyGvEXHhfs8M7ZnMMKBNJjG1A@mail.gmail.com>
	<20131213190707.GA9713@roeck-us.net>
	<CACmBeS2_WZj6_HJo0N50TBwneNVmeB9TyXbHRLm9CJFGNN+HtQ@mail.gmail.com>
	<52AC7E41.7050201@roeck-us.net>
Date: Sat, 14 Dec 2013 17:26:25 +0100
Message-ID: <CACmBeS3Xse5KkFqkM5Ye+qaaxpVCjyeGz7Oc9sr0PN+pZ9sztQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 December 2013 16:50, Guenter Roeck <linux@roeck-us.net> wrote:
> The above would at least avoid the crash, though I would not understand
> the point of having an unloadable restart handler. Forcing the watchdog
> driver into the kernel just because you want the restart handler in it
> would seem odd. And if the restart handler is optional, why have it
> in the first place ? I also don't follow Arnd's logic of wanting to have
> the code in the watchdog driver just because it happens to use a register
> that it needs.
>
> Conceptually it might be cleaner to write a separate driver, for example
> in drivers/power/restart, than plugging the functionality into
> the watchdog driver, at least if you don't want it in architecture
> or platform code. The xgene restart driver is a good example.
>
> Anyway, it is not up to me to accept the code, that is up to Wim.
> My rejection was primarily due to technical flaws, which can be addressed.
> For the logical reasoning you'll have to convince Wim.

Thanks for the replies.

Moving it to a new power/restart driver seems reasonable to me, I'm
really just looking for a home for it, I would have preferred a
hardware with reset in a separate register though.

I now plan to remove it for v5 and submit a separate driver.


Regards,
Jonas
