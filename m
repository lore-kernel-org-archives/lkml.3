Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaIEIDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:03:18 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36786 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIEIDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:03:14 -0400
MIME-Version: 1.0
In-Reply-To: <1409415565-13232-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409415565-13232-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Fri, 5 Sep 2014 10:03:13 +0200
Message-ID: <CACRpkdbunsVd5Y2aiS6dXAgD6DpyFe8ukm12n7YM97M=q7X+mQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: bcm281xx: Add remove function to pinctrl_unregister
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sherman Yin <syin@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 6:19 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This patch adds a remove function in platform_driver to pinctrl_unregister
> for clean unloading.
> This makes local struct pinctrl_dev a part of struct bcm281xx_pinctrl_data to
> be accessed from pdev in remove function.
>
> CC: Sherman Yin <syin@broadcom.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Since this driver is a "bool" in Kconfig, it is not loaded as a module
and .remove() is never called.

So this is unnecessary.

Yours,
Linus Walleij
