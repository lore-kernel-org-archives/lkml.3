Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbaD3MFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:05:16 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36590 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbaD3MFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:05:14 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.217]
In-Reply-To: <535FD0E0.70809@metafoo.de>
References: <1398595800-6683-1-git-send-email-javier@dowhile0.org>
	<535FD0E0.70809@metafoo.de>
Date: Wed, 30 Apr 2014 14:05:12 +0200
Message-ID: <CABxcv=kN+79-BuBcLat=OO4Ba0eAbyVudwt0K=vUOGiiB-A3fQ@mail.gmail.com>
Subject: Re: [Cocci] [PATCH v2 1/1] scripts/coccinelle: use BIT macro if used
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Coccinelle <cocci@systeme.lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lars,

On Tue, Apr 29, 2014 at 6:18 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 04/27/2014 12:50 PM, Javier Martinez Canillas wrote:
>>
>> Using the BIT() macro instead of manually shifting bits
>> makes the code less error prone.
>>
>> If is more readable is a matter of taste so only replace
>> if the file is already using this macro.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>
>
>
> I don't think this should be enabled by default. It will generate a ton of
> false positives, not everything that is 1 shifted by something is a
> single-bit field. E.g. imagine a device with multi-bit fields:
>
> #define FOOBAR_A (0 << FOOBAR_OFFSET)
> #define FOOBAR_B (1 << FOOBAR_OFFSET)
> #define FOOBAR_C (2 << FOOBAR_OFFSET)
> #define FOOBAR_D (3 << FOOBAR_OFFSET)
>
> The script will now suggest to replace FOOBAR_B (1 << FOOBAR_OFFSET) with
> FOOBAR_B BIT(FOOBAR_OFFSET). Which is technically correct, but not
> semantically.
>
> - Lars
>
>

Thanks a lot for your feedback. You are complete right that this is
hard to generalize so is better to just drop this patch.

I'll just continue it keeping it on my tree since I find it useful.

Best regards,
Javier
