Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3DCOJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:09:13 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:39042 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346Ab3DCOJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <5154827B.8010701@wwwdotorg.org>
References: <1364490685-21831-1-git-send-email-bbasu@nvidia.com>
	<5154827B.8010701@wwwdotorg.org>
Date: Wed, 3 Apr 2013 16:09:09 +0200
Message-ID: <CACRpkdYLSVkfAxVBMBnkyePujaoQQqB27UiG+-r2APkEDrfLrA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: add suspend-resume support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bibek Basu <bbasu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 6:48 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Why can't we just use the device suspend/resume functions rather than
> global (syscore) suspend/resume functions? Presumably this is to ensure
> that all other drivers suspend first, then the pinctrl driver does, and
> the reverse for resume. Can't we rely on deferred probe to ensure that
> instead?
>
> To make that work, we might need every affected driver to define a dummy
> pinmux state in DT that references the pinctrl driver, to make sure they
> all get probed after the pinctrl driver.

Hm that reminds me of that policy change I suggested a while back to
do this instead of using hogs where possible.

It has the nice side-effect that when we inspect the debugfs info
all pins will be properly owned by respective consuming device.

Yours,
Linus Walleij
