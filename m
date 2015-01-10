Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbbAJPOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 10:14:38 -0500
Received: from mail-lb0-f195.google.com ([209.85.217.195]:43797 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbbAJPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 10:14:36 -0500
MIME-Version: 1.0
Date: Sat, 10 Jan 2015 23:14:33 +0800
Message-ID: <CADcZZT+nQ_0LfurU+z5wLC_OxNhEs6n0kCoLSkfoFCDqyOu04g@mail.gmail.com>
Subject: ARM64: hibernation: How to use hibernation/suspend-to-disk on ARMv8?
From: George Bush <georgebush815@gmail.com>
To: sebastian.capella@linaro.org, Russ.Dill@ti.com, rjw@rjwysocki.net,
        linux@arm.linux.org.uk, len.brown@intel.com, nico@linaro.org,
        santosh.shilimkar@ti.com, will.deacon@arm.com, jonathan.austin@arm.com,
        catalin.marinas@arm.com, u.kleine-koenig@pengutronix.de,
        sboyd@codeaurora.org, victor.kamensky@linaro.org, r.sricharan@ti.com,
        liuj97@gmail.com, lauraa@codeaurora.org, zhou0283@gmail.com
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I notice we have hibernation.c in arm/kernel, however, I don't find it in arm64.
Does it mean arm64 do not support hibernation/suspend-to-disk function?

I tried some path to search the reason, but found nothing, they all say arm64
has the backward compatibility. So I send this email to the community and
hope to get the reason.
Thanks!

I ported the arm hibernation.c to arm64/kernel(with LP64), but failed in a
strange way. When I do resume, the arch_restore_image() get a page_fault
when it calls the copy_page(), like:
"Unable to handle kernel paging request at virtual address 0xffffffbc055c3fa8"
I'm sure the copy_page()'s parameters is in the memory area, why and how
I get the strange address 0xffffffbc055c3fa8?

vmalloc:         0xffffff8000000000 - 0xffffffbb00000000
vmemmap:     0xffffffbc01400000 - 0xffffffbc04f88000
modules:       0xffffffbffc000000   -  0xffffffc000000000
memory:        0xffffffc000000000 - 0xffffffc0be800000


Look forward to your reply, thanks!
