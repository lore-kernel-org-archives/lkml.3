Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbbAIKWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:22:45 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:53945 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756397AbbAIKWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:22:44 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH] pinctrl: pass -DDEBUG in subdirs
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>
In-Reply-To: <1420796506-10402-1-git-send-email-linus.walleij@linaro.org>
References: <1420796506-10402-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 9 Jan 2015 18:22:36 +0800
Message-ID: <1420798956.23114.18.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2015-01-09 at 10:41 +0100, Linus Walleij wrote:
> When drivers are compiled in subdirectories the -DDEBUG flag need
> to be passed in the individual Makefiles.

Hi,

It will be easy to forget adding this when adding new subdirectories.
Can we do this instead?

diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index af365c5..36f1d620 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -1,6 +1,6 @@
 # generic pinmux support

-ccflags-$(CONFIG_DEBUG_PINCTRL)        += -DDEBUG
+subdir-ccflags-$(CONFIG_DEBUG_PINCTRL) += -DDEBUG

Joe.C



