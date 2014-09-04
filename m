Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaIDIeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:34:09 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:56406 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaIDIeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <5407BCAE.7030606@huawei.com>
References: <1409550563-92081-1-git-send-email-long.wanglong@huawei.com>
 <540443DA.7030502@huawei.com> <25226905.0IHWyHSRxb@wuerfel> <5407BCAE.7030606@huawei.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 4 Sep 2014 09:33:43 +0100
Message-ID: <CAFEAcA82zX-yodXYB+4vVrjq7tVe=wV4v3iCQ7O1a1HLFX_B1w@mail.gmail.com>
Subject: Re: [SMP BUG?] the return value of is_smp() is bug?
To: "long.wanglong" <long.wanglong@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        nico@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        santosh.shilimkar@ti.com, Christopher Covington <cov@codeaurora.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2014 02:13, long.wanglong <long.wanglong@huawei.com> wrote:
> When i revert the commit bc41b8724f24, the secondary core can boot.
> The problem is that qemu doesn't provide emulation of the SCU base
> address register. When reading the SCU base, qemu just return 0.

You need to upgrade your QEMU -- we improved the emulation
of all our Cortex-A9 boards to make sure they set valid values
for the base address register, in order to fix exactly this regression.
QEMU 2.0 or later should work.

(As an aside, I think the Aegis quirk test is pretty ugly:
"base address happens to be set to zero" is not exactly
a very reliable way to identify a particular SoC. However
in this case QEMU was emulating real h/w insufficiently
accurately, so we fixed it.)

thanks
-- PMM
