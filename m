Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab3D2MxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:53:05 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58240 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3D2MxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <1366984629.31523.1.camel@phoenix>
References: <1366984629.31523.1.camel@phoenix>
Date: Mon, 29 Apr 2013 14:53:02 +0200
Message-ID: <CACRpkdaPMfLu3Vi8BfETadvWJbEqf-S2XBAtbeHSr0PjgBWbaQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab3100: Fix regulator register error handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 3:57 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Ensure to unregister all regulators before return error in probe().
>
> The regulator register order depends on the regulator ID pass to
> ab3100_regulator_register() function. Thus we need to scan ab3100_regulator_desc
> and find the index of successfully registered regulators, or alternatively just
> call ab3100_regulators_remove() to unregister all registered regulators.
>
> Since current code uses a static ab3100_regulators table, explicitly set
> reg->rdev = NULL after regulator_unregister() call to ensure calling
> ab3100_regulators_remove() in the unwind path always work.
>
> Also move ab3100_regulators_remove() to avoid forward declaration.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Excellent patch Axel, thanks!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
