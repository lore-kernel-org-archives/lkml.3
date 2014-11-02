Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaKBWTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:19:48 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:11108 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbaKBWTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:19:45 -0500
Message-ID: <5456ADF2.8080400@tremplin-utc.net>
Date: Sun, 02 Nov 2014 23:19:30 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Giedrius Statkevicius <giedriuswork@gmail.com>
CC: dvhart@infradead.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH v2] platform: hp_accel: add a i8042 filter to remove HPQ6000
 data from kb bus stream
References: <1414688267-29676-1-git-send-email-giedriuswork@gmail.com>
In-Reply-To: <1414688267-29676-1-git-send-email-giedriuswork@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-10-14 17:57, Giedrius Statkevicius wrote:
> Add a i8042 filter to hp_accel to remove accelerometer's data with acpi
> id HPQ6000 from keyboard bus stream. The codes sent by accelerometer are
> e0 25, e0 26, e0 27 and e0 28. The relevant information is already
> passed through /dev/freefall so no need to send these undocumented weird
> signals through the keyboard bus. Also, unclogs `dmesg` because atkbd
> complained about weird scan codes, saves processing power and disk
> space.
>
> Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Hi,
Looks fine with respect to the hp accel driver. If Dmitry thinks the 
behaviour is fine then I've got nothing more to say :-)

Reviewed-by: Éric Piel <eric.piel@tremplin-utc.net>

Darren, could you pick up this patch in your tree?

Cheers,
Éric


> ---
> Changes in v2:
> * Remove a unnecessary deletion of a blank line
> * Move #includes of i8042.h and serio.h before the relative path
>    includes.
>
> First of all, any Tested-Bys are very welcome by people who also have a
> accelerometer with acpi id HPQ6000. If it happens with HPQ6007 too we
> can easily modify this to install the filter when HPQ6007 is detected.
> For the time being the filter is only installed when HPQ6000 is
> detected.
>
> Now moving to what was changed since the RFC. I reworked the filter
> function to hopefully make it more clear what it is doing. Since the
> codes sent by the accelerometer are extended then we need to filter all
> of 0xe0's and then send one 0xe0 back when the actual key isn't in the
> range of 0x25-0x28. Also, I've removed the check for errors for
> i8042_install_filter() because it's unnecessary to check if it failed.
> If multiple HPQ6000's are in the system then no issue occurs even if
> multiple i8042_install_filter() are issued because this is handled by
> i8042 and it's smart enough not to install the same filter two or more
> times.
>
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=84941.
:
