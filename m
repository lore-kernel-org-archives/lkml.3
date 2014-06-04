Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaFDOfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:35:44 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:55448 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaFDOfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:35:43 -0400
MIME-Version: 1.0
X-Originating-IP: [188.149.52.16]
In-Reply-To: <s5hlhtc21bg.wl%tiwai@suse.de>
References: <1401733474-1767-1-git-send-email-teg@jklm.no> <s5hr43421un.wl%tiwai@suse.de>
 <s5hlhtc21bg.wl%tiwai@suse.de>
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 4 Jun 2014 16:35:22 +0200
Message-ID: <CAG-2HqVkbXV4Z3JJHXiMxyhna+HCeswwXbsjWXH=Uh0yLm6YgA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: allow disabling of udev as firmware loader
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 4:31 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 04 Jun 2014 16:20:16 +0200,
> Takashi Iwai wrote:
>>
>> At Mon,  2 Jun 2014 20:24:34 +0200,
>> Tom Gundersen wrote:
>> >
>> > Currently (at least) the dell-rbu driver selects FW_LOADER_USER_HELPER,
>> > which means that distros can't really stop loading firmware through udev
>> > without breaking other users (though some have).
>> >
>> > Ideally we would remove/disable the udev firmware helper in both the kernel
>> > and in udev, but if we were to disable it in udev and not the kernel, the result
>> > would be (seemingly) hung kernels as no one would be around to cancel firmware
>> > requests.
>> >
>> > This patch allows udev firmware loading to be disabled while still allowing
>> > non-udev firmware loading, as done by the dell-rbu driver, to continue
>> > working. This is achieved by only using the fallback mechanism when the
>> > uevent is suppressed.
>> >
>> > Tested with
>> >     FW_LOADER_USER_HELPER=n
>> >     LATTICE_ECP3_CONFIG=y
>> >     DELL_RBU=y
>> > and udev without the firmware loading support, but I don't have the hardware
>> > to test the lattice/dell drivers, so additional testing would be appreciated.
>>
>> The logic of this patch looks good to me, but the Kconfig items become
>> confusing by this.  Basically what we'd need is a Kconfig item
>> deciding whether to build the user helper or not, in addition to a
>> Kconfig item for deciding the fallback mode of request_firmware().
>>
>> What about the patch like below instead?  It's smaller and the meaning
>> of Kconfig items are clearer.  (In the final form, the help text
>> change you added should be included there, too.)
>>
>> The only (and biggest) drawback is, however, that the user-selectable
>> Kconfig would be actually renamed from CONFIG_FW_LOADER_USER_HELPER to
>> CONFIG_FW_LOADER_USER_HELPER_FALLBACK.
>
> Also, since it's deprecated in the udev upstream, let's drop "default
> y", too.  (It can be another patch, though.)


Yes, absolutely, this should default to "n".

Cheers,

Tom
