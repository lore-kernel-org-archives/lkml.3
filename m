Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab3HNPyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:54:35 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:61038 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3HNPyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <1376458003-6244-1-git-send-email-sonic.adi@gmail.com>
References: <1376458003-6244-1-git-send-email-sonic.adi@gmail.com>
Date: Wed, 14 Aug 2013 17:54:32 +0200
Message-ID: <CACRpkdZbZF6pHdfgrFqf-Uuoipv=vmK7Y4CCqPjj21QYN-zNfA@mail.gmail.com>
Subject: Re: [PATCH v4] pinctrl: pinmux: Don't free pins requested by other
 devices in pinmux_disable_setting.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 7:26 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> One peripheral may share part of its pins with the 2nd
> peripheral and the other pins with the 3rd. If it requests all pins
> when part of them has already be requested and owned by the 2nd
> peripheral, this request fails and pinmux_disable_setting() is called.
> The pinmux_disable_setting() frees all pins of the first peripheral
> without checking if the pin is owned by itself or the 2nd, which
> results in the malfunction of the 2nd peripheral driver.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Hm it makes some sense so patch applied.

That said I think we currently have drivers where a pin group
mapped to a certain function in a certain setting  *usually*
don't overlap with pins in another group used with another
function, and having it so seems racy, i.e. it will be some
first-come-first-serve effect.

I will add a warning print.

Yours,
Linus Walleij
