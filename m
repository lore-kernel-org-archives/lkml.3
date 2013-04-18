Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936696Ab3DRWFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:05:50 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64045 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936487Ab3DRWFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:05:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:c028]
In-Reply-To: <1366322130-19364-1-git-send-email-olof@lixom.net>
References: <1366322130-19364-1-git-send-email-olof@lixom.net>
Date: Thu, 18 Apr 2013 15:05:47 -0700
Message-ID: <CAOesGMj6nyjYjxQ23Vk0L76fYQo7YPeKoKrPptq8TVdv7Cwa-g@mail.gmail.com>
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

On Thu, Apr 18, 2013 at 2:55 PM, Olof Johansson <olof@lixom.net> wrote:
> If chromeos_laptop is loaded before the DRM driver, the i2c busses will
> not yet be available. Defer probe for that case and try again later.
>
> Trickling the error up to the module init function is unfortuantely a
> little awkward, since the i2c bus lookup and device registration happens
> as a dmi callback.

Uh, wait, hold off on this. I'm returning -EPROBE_DEFER from the
module init function. It's not valid outside of the driver model.


-Olof
