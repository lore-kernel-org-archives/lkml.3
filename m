Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbaICN2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:28:12 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62465 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbaICN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:28:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Xia Kaixu <kaixu.xia@linaro.org>, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>, linaro-kernel@lists.linaro.org,
        Anton Vorontsov <anton@enomsg.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PATCH] ARM: cns3xxx: fix allmodconfig panic in pci driver
Date: Wed, 03 Sep 2014 15:27:30 +0200
Message-ID: <2886818.zPBP0DOepO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409750292-24105-1-git-send-email-kaixu.xia@linaro.org>
References: <kaixu.xia@linaro.org> <1409750292-24105-1-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XlwZg5D8nZgO64kySLylahTyU4ba1Zm5Bb3MhEDvK0A
 L2slOem6dI7ARC852GkqKBUslTgPKiZ9qQY0PO2ORTYlVfSzaO
 Q16cLV8jnQDOfVOV4PBxgFfG8rF8EsQHE3wFZhjVUxAnZcSGUT
 ZYbXr9PUwTEICSnu5wLyN19hBYwpyfcKcPSLI/SxUs8lJb/cxB
 n5s7Shv3KTD6vMhbi8jmzL05XSScWweL5RtUdcsOs0QDEphNPg
 ro4A4zPGZprbAL9lxMzOIe/CpMwvkjJK90O9cmosJ2B/U2vbiy
 XVUXWD3Z6R0goE7GsBWHPt79bXaYMq1ZwitOZfP+BT/kBCSXT1
 LdGu15tT9reH1do9hnaY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 21:18:12 Xia Kaixu wrote:
> From: Xia Kaixu <kaixu.xia@linaro.org>
> 
> The kernel panic occurs when running an allmodconfig kernel on 
> OMAP4460. The inicall "cns3xxx_pcie_init" does not check which
> hardware it's running on and just tries to access to its specific 
> registers. Now call it from .init_late callback from the two
> machine descriptors.
> 
> Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Felix Fietkau <nbd@openwrt.org>
> Cc: Imre Kaloz <kaloz@openwrt.org>
> Cc: linaro-kernel@lists.linaro.org
> Cc: linux-arm-kernel@lists.infradead.org

Hi Kaixu,

it seems this time all the Cc's worked. One thing I just noticed is that
you confused the 'Signed-off-by' lines. I did look at the patch earlier
before you sent it out but unfortunately missed that.

You can read again in Documentation/SubmittingPatches about how
they work, but the short version is that you must never put someone
else's name in Signed-off-by under a patch you write yourself.
When we apply the patch, I (or whoever else does) will put that
line below yours to document who handled the patch.

Otherwise, the patch looks good to me, thanks a lot for doing it.

	Arnd
