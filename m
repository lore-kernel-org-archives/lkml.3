Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3JBVIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:08:53 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:53855 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab3JBVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:08:50 -0400
MIME-Version: 1.0
In-Reply-To: <20131002114359.681cbdf92bd683373f07cca2@linaro.org>
References: <1380712124-20666-1-git-send-email-taras.kondratiuk@linaro.org>
	<20131002114359.681cbdf92bd683373f07cca2@linaro.org>
Date: Thu, 3 Oct 2013 00:08:49 +0300
Message-ID: <CAArO44vKdn5Zmwd+qLm1pRsDKNSgEWx_H2Z-CwEJxcyLfu320Q@mail.gmail.com>
Subject: Re: [LNG] [PATCH] mfd: twl6030: Fix endianness problem in IRQ handler
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linaro Networking <linaro-networking@linaro.org>,
        d.xie@sta.samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2013 19:43, Kim Phillips <kim.phillips@linaro.org> wrote:
> On Wed,  2 Oct 2013 14:08:44 +0300
> Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:
>
>> From: Danke Xie <d.xie@sta.samsung.com>
>>
>> The current TWL 6030 IRQ handler assumes little endianness.
>> This change makes it endian-neutral.
>>
>> Signed-off-by: Danke Xie <d.xie@sta.samsung.com>
>> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
>> ---
>
> this patch causes a new sparse warning:
>
> make C=2 CF="-D__CHECK_ENDIAN__" drivers/mfd/twl6030-irq.o
> ...
>   CHECK   drivers/mfd/twl6030-irq.c
> drivers/mfd/twl6030-irq.c:200:19: warning: cast to restricted __le32
>
> does int_sts in the sts union need to be defined as __le32?

You are right.
I will update the patch.

-- 
Regards,
Taras Kondratiuk
