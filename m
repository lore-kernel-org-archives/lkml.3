Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967375Ab3DRWoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:44:23 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51026 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966174Ab3DRWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:44:21 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:c028]
In-Reply-To: <CAOesGMj6nyjYjxQ23Vk0L76fYQo7YPeKoKrPptq8TVdv7Cwa-g@mail.gmail.com>
References: <1366322130-19364-1-git-send-email-olof@lixom.net>
	<CAOesGMj6nyjYjxQ23Vk0L76fYQo7YPeKoKrPptq8TVdv7Cwa-g@mail.gmail.com>
Date: Thu, 18 Apr 2013 15:44:20 -0700
Message-ID: <CAOesGMg5F-+Sco0sA1s2ACD2ZcqG2Z1Ovq51oyo=fO19S6Njfg@mail.gmail.com>
Subject: Re: [PATCH] Platform: x86: chromeos_laptop: defer probing if no i2c
 busses found
From: Olof Johansson <olof@lixom.net>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>, dirk@hohndel.org,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 3:05 PM, Olof Johansson <olof@lixom.net> wrote:
> On Thu, Apr 18, 2013 at 2:55 PM, Olof Johansson <olof@lixom.net> wrote:
>> If chromeos_laptop is loaded before the DRM driver, the i2c busses will
>> not yet be available. Defer probe for that case and try again later.
>>
>> Trickling the error up to the module init function is unfortuantely a
>> little awkward, since the i2c bus lookup and device registration happens
>> as a dmi callback.
>
> Uh, wait, hold off on this. I'm returning -EPROBE_DEFER from the
> module init function. It's not valid outside of the driver model.

Ugh. Ok, so that worked just because any error seem to re-trigger an
attempt to load the module later on my system (three times, it seems),
and most of the reproductions I had happened to work out on the second
load.

Looks like keeping the module loaded and adding a bus notifier to wait
for the right busses to show up is the only way to do this in a
foolproof way. Revised patch tonight or tomorrow.


-Olof
