Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3GTVIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 17:08:51 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53838 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab3GTVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 17:08:49 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <CACRpkdbLhjRa-6OFK1++5eTFk5+GP7PuDw6GXmSj-F8MgxG0_w@mail.gmail.com>
References: <1372170465-28450-1-git-send-email-james.hogan@imgtec.com>
	<1372170465-28450-4-git-send-email-james.hogan@imgtec.com>
	<CACRpkdbLhjRa-6OFK1++5eTFk5+GP7PuDw6GXmSj-F8MgxG0_w@mail.gmail.com>
Date: Sat, 20 Jul 2013 22:08:48 +0100
X-Google-Sender-Auth: BrJ4PW_KOrWLYEA9CnAlJmFI8bY
Message-ID: <CAAG0J98sP2RqyHU-i_vf3pfr21H=tBGjstT_W6TX7RFbFfKMuQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] gpio-tz1090: convert to use generic irqchip
From: James Hogan <james.hogan@imgtec.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 July 2013 18:07, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jun 25, 2013 at 4:27 PM, James Hogan <james.hogan@imgtec.com> wrote:
>
>> Convert gpio-tz1090 driver to use generic irqchips. This allows the
>> irq_ack, irq_mask, and irq_unmask callbacks and associated helper
>> functions to be removed. Also switch to using irq_setup_alt_chip() in
>> the irq_set_type callback instead of using __irq_set_handler_locked().
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> ---
>> This patch depends on the generic irqchip linear irqdomain work in
>> tip/irq/core.
>>
>> Changes in v4:
>
> Patch applied. Confirm that the infrastructure is now upstream
> pls, this is applied on top of v3.11-rc1.

Thanks Linus. Yes, the linear irq domain support in generic irqchip
was included in v3.11-rc1, specifically:
088f40b genirq: Generic chip: Add linear irq domain support
(and related commits)

I'll queue the corresponding arch/metag device tree changes.

Cheers
James
