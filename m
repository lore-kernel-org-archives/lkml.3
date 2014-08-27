Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbaH0RuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:50:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48672 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbaH0RuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:50:12 -0400
Message-ID: <53FE1A2B.80204@zytor.com>
Date: Wed, 27 Aug 2014 10:49:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>	<53FD01D0.8020203@zytor.com> <CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 03:05 PM, Yinghai Lu wrote:
> 
> The firmware has bug and can use buffer above 4G to read files.
> and if the file size is 512 bytes alignment, then reading could go through.
> 

File size, or alignment?  Different things.  Again, your patch
description is not just incomplete, but seems to be actively misleading.

This does, however, suggest at least two possible solutions:

1. We can read the initramfs into a temporary buffer and memcpy() it to
the target.

2. We might be able to align the initramfs buffer to a 512-byte section
and then round up the size.

The 512 bytes here is probably a hardware sector, I'm not sure how this
will play on 4K-hard-sectored media, although those are few and far between.

	-hpa

