Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3DZMG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:06:27 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:60858 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3DZMGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFEAcA_xmrHTvR7FxUr3PCKBJY-hZnkeBcqyHksTB4-hqOZS0w@mail.gmail.com>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
	<BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
	<CAFEAcA_xmrHTvR7FxUr3PCKBJY-hZnkeBcqyHksTB4-hqOZS0w@mail.gmail.com>
Date: Fri, 26 Apr 2013 17:36:16 +0530
Message-ID: <CALrVBkuOmu4u9egdzzfn1tU9B-CFe3w85HZQ9s2gpKvYnaSqvA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
From: Anup Patel <anup.patel@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alexander Graf <agraf@suse.de>, linaro-kernel@lists.linaro.org,
        patches@linaro.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 17:03, Peter Maydell <peter.maydell@linaro.org> wrote:
> On 26 April 2013 12:19, Alexander Graf <agraf@suse.de> wrote:
>> MMIO registers are handled by a different layer than the virtio
>> console itself. After the virtio refactoring in QEMU, they will
>> be completely separate drivers.
>
> Good point -- we don't really want to be mixing up the
> transport and the backend. You can see it in the kvmtool
> patch, in fact -- it introduces an "if this is virtio-console"
> special case into the mmio.c file which previously was
> entirely backend agnostic.

Well, we can always have virtio device specific config registers
handle by virtio device backends and generic virtio config register
handled by transport.

kvmtool patch is hacky because it does not provide virtio device
specific config read/write callbacks.

>
> thanks
> -- PMM
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/cucslists/listinfo/kvmarm

--Anup
