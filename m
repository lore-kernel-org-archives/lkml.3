Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3LTJh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:37:56 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:43050 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab3LTJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:37:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131217001842.GB3840@sonymobile.com>
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-4-git-send-email-syin@broadcom.com>
	<CACRpkdauqYNiby-ta3c_he2ovG__0e6ubmzZ8Bx1cP_OzK4=LQ@mail.gmail.com>
	<CAEPRUYpsp_FVobY_DeEQU2+rCD7q7T=p7k++XvG-22x-OWHY8Q@mail.gmail.com>
	<CACRpkdY2BExGiL6HBg7zn_szJQMnSNsxOSuo7RyrRmrz=cVe2A@mail.gmail.com>
	<20131217001842.GB3840@sonymobile.com>
Date: Fri, 20 Dec 2013 10:37:51 +0100
Message-ID: <CACRpkdY-MM7OoMq_L90YRADy=oaDoV1wAOccVz90LqfRfEh=3Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] pinctrl: Make PINCTRL selectable by defconfig/menuconfig
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Christian Daudt <bcm@fixthebug.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Heiko St?bner" <heiko@sntech.de>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Sherman Yin <syin@broadcom.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 1:18 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:

> No matter how we build the individual pinctrl drivers we will always
> need the pinctrl framework in a multi-soc zImage; so I can't see that
> we gain anything from being able to compile PINCTRL as a module.

I discussed this matter with Christian on IRC and I believe we could
basically do "select PINCTRL" on ARCH_MULTIPLATFORM as the
vast majority of multiplatforms appear to be using this anyway, this
would make the submenu for pin control pop up in menuconfig
for this, and make it possible to move different subdrivers to modules
if desired.

MULTIPLATFORM does not seem to be about saving footprint bytes
on a very fine-granular level anyway, more about doing the module
loading/unloading approach to footprint.

(That drivers such as clk, regulator, pin control, GPIO, irqchip are
usually impossible to rmmod as their tentacles will invariably be
in all drivers everywhere is another issue, but this approach will solve
modular *loading* atleast.)

Yours,
Linus Walleij
