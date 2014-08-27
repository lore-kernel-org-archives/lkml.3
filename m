Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935653AbaH0Su1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:50:27 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44187 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaH0SuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <53FE1A2B.80204@zytor.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<53FD01D0.8020203@zytor.com>
	<CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
	<53FE1A2B.80204@zytor.com>
Date: Wed, 27 Aug 2014 11:50:25 -0700
X-Google-Sender-Auth: FxhRCHLZ0YIwjYJktc9UBrcuVTo
Message-ID: <CAE9FiQXRZ8j-d=qOji7D_mBeSurXbwMz52UYgd1C04ihV9K0NA@mail.gmail.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 10:49 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/26/2014 03:05 PM, Yinghai Lu wrote:
> This does, however, suggest at least two possible solutions:
>
> 1. We can read the initramfs into a temporary buffer and memcpy() it to
> the target.
>
> 2. We might be able to align the initramfs buffer to a 512-byte section
> and then round up the size.
>
> The 512 bytes here is probably a hardware sector, I'm not sure how this
> will play on 4K-hard-sectored media, although those are few and far between.

efi_high_alloc() already round up the buffer size with EFI_PAGE_SIZE
(it is 4KiB now), and the buffer is aligned to EFI_PAGE_SIZE.

Yinghai
