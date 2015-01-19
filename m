Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbbASKfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:35:50 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39027 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbASKfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:35:48 -0500
MIME-Version: 1.0
In-Reply-To: <1421376639.31355.169.camel@mtksdaap41>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	<1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
	<1418807365.6443.17.camel@mtksdaap41>
	<1420535817.17567.10.camel@mtksdaap41>
	<CACRpkdb2KJbjzFgTmDvHSw7jNAExxVtU3y4_fgyn6J8hcW5OrQ@mail.gmail.com>
	<1421202745.27675.148.camel@mtksdaap41>
	<CACRpkdY7_A_rORDvDrGtV0aa6mJGj=Sr-k=KVGu_=0et-gNpiQ@mail.gmail.com>
	<1421376639.31355.169.camel@mtksdaap41>
Date: Mon, 19 Jan 2015 11:35:47 +0100
Message-ID: <CACRpkda4dqY4uMmCz_uFB_n50A3OpSBr4p1g0sZ8Kty5Ou+gkg@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] ARM: mediatek: Add EINT support to MTK pinctrl driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>, maoguang.meng@mediatek.com,
        Russell King <linux@arm.linux.org.uk>, srv_heupstream@mediatek.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, alan.cheng@mediatek.com,
        toby.liu@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, dandan.he@mediatek.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 3:50 AM, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
> On Thu, 2015-01-15 at 18:30 +0100, Linus Walleij wrote:

>> But the EINT is not a hardware number is it?
>
> It is a hardware number. eg, to mask irq for the gpio 0 above, we have
> to set bit49 in EINT mask_set register. When this irq triggered, it is
> reported using EINT status register bit49.

OK I get it (finally) then you should indeed use the irqdomain for it...
It's just a bit confusing that it begins at offset 49...

Yours,
Linus Walleij
