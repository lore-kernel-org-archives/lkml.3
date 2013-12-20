Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3LTVAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:00:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3LTVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:00:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/6] pinctrl: Make PINCTRL selectable by defconfig/menuconfig
Date: Fri, 20 Dec 2013 21:58:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Heiko St?bner" <heiko@sntech.de>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Sherman Yin <syin@broadcom.com>,
        "bcm-kernel-feedback-list" <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1381174108-25168-1-git-send-email-syin@broadcom.com> <20131217001842.GB3840@sonymobile.com> <CACRpkdY-MM7OoMq_L90YRADy=oaDoV1wAOccVz90LqfRfEh=3Q@mail.gmail.com>
In-Reply-To: <CACRpkdY-MM7OoMq_L90YRADy=oaDoV1wAOccVz90LqfRfEh=3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312202158.34805.arnd@arndb.de>
X-Provags-ID: V02:K0:wq//Lm6KNx1BUvst9m/KpakVr195RSY4xz1wiGPWb2U
 lU3cUhbEKqaIrzTXjqEToVYnOy964wdST2TF3di3nK7/bR/zjh
 PAXHIjta7bpqXu8Z34h2GvuxpVGU+Jn4jnAG/+/OEcVIfC0/BZ
 Wfh13NJ7Lx7wEeWPTepS6/sm3DtxhgvLGxSPSTav4Vusumj8fb
 mQbcldxz6YWIvvegtEgne9qLkSHmFzpmzGamKxiFKi3u6q3Jlx
 LpS6OYmOnLr0/nXxiPpu/K6yFakcceLv9Hg1ICzLYG3dr0fABW
 3Lm9UEFyojVd7ooD3ZyZRpCpn7t99gB1njA+489EEQm08tmolc
 fVLqXuQUFDSl2EESaVJM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 December 2013, Linus Walleij wrote:
> On Tue, Dec 17, 2013 at 1:18 AM, Bjorn Andersson
> <bjorn.andersson@sonymobile.com> wrote:
> 
> > No matter how we build the individual pinctrl drivers we will always
> > need the pinctrl framework in a multi-soc zImage; so I can't see that
> > we gain anything from being able to compile PINCTRL as a module.
> 
> I discussed this matter with Christian on IRC and I believe we could
> basically do "select PINCTRL" on ARCH_MULTIPLATFORM as the
> vast majority of multiplatforms appear to be using this anyway, this
> would make the submenu for pin control pop up in menuconfig
> for this, and make it possible to move different subdrivers to modules
> if desired.
> 
> MULTIPLATFORM does not seem to be about saving footprint bytes
> on a very fine-granular level anyway, more about doing the module
> loading/unloading approach to footprint.

Let's review the list of platforms that don't select PINCTRL. There
are some platforms that are indeed sensitive about memory footprint,
and I promised people that converting to multiplatform won't cause
a significant increase in kernel binary size as long as no other
platforms are enabled.

	Arnd
