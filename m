Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaCYNWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:22:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46537 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaCYNWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:22:46 -0400
Message-ID: <533182C3.9060708@ti.com>
Date: Tue, 25 Mar 2014 09:21:07 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: boot: dts: build keystone devicetree blob
References: <1394639330-1288-1-git-send-email-balbi@ti.com> <53208CDD.7030106@ti.com> <532C4F40.5010903@ti.com> <20140321144328.GC12310@saruman.home>
In-Reply-To: <20140321144328.GC12310@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 March 2014 10:43 AM, Felipe Balbi wrote:
> On Fri, Mar 21, 2014 at 10:40:00AM -0400, Santosh Shilimkar wrote:
>> On Wednesday 12 March 2014 12:35 PM, Santosh Shilimkar wrote:
>>> On Wednesday 12 March 2014 11:48 PM, Felipe Balbi wrote:
>>>> Currently, even when building keystone only
>>>> kernel builds, DTB won't get build because
>>>> we lack a Makefile rule to get it compiled.
>>>>
>>>> This patch adds that rule so mainline kernel
>>>> users have a chance to use up-to-date DTB on
>>>> keystone 2 platforms.
>>>>
>>>> Signed-off-by: Felipe Balbi <balbi@ti.com>
>>>> ---
>>>>
>>> We have been building dtbs with explicit command
>>> instead of dtbs since it was just one dtb so far
>>> supported. Was planning to add the rule once more
>>> boards get added. Now with Lamarr and Edision in
>>> for next merge window, will do that post 3.15-rc1.
>>>
>> Just to close the loop, I added a patch as part
>> of my 3.15 fixes which builds all keystone dt
>> blobs.
> 
> cool, thanks
> 
Here is the updated patch which I commited to fixes branch.
Sorry to miss your reported-by tag. I just missed it.

>From 400550ae7e778302a45d2952ac75907903e2610c Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Tue, 18 Mar 2014 16:02:34 -0400
Subject: [PATCH] ARM: dts: Build all keystone dt blobs

Now we have additional two SOC/boards supported, so add
make file rule so that all device tree blobs can be build
for keystone with 'make dtbs'.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/boot/dts/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b9d6a8b..49ff796 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -81,6 +81,9 @@ dtb-$(CONFIG_ARCH_HIGHBANK) += highbank.dtb \
 	ecx-2000.dtb
 dtb-$(CONFIG_ARCH_INTEGRATOR) += integratorap.dtb \
 	integratorcp.dtb
+dtb-$(CONFIG_ARCH_KEYSTONE) += k2hk-evm.dtb \
+	k2l-evm.dtb \
+	k2e-evm.dtb
 dtb-$(CONFIG_ARCH_LPC32XX) += ea3250.dtb phy3250.dtb
 dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-db-88f6281.dtb \
-- 
1.7.9.5


