Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaGGPrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:47:52 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44199 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaGGPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <1403790091-11423-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403790091-11423-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:47:50 +0200
Message-ID: <CACRpkdbHGSY4tiRy0pOmRKdLMQx3nOvGwF7mE-8G24-8b7LN8A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-at91.c: Cleaning up values that are
 never used
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 3:41 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove variable that are never used
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
(...)
> -       int ret, val, num_conf = 0;
> +       int val, num_conf = 0;
>
> -       ret = at91_pinconf_get(pctldev, pin_id, &config);
> +       at91_pinconf_get(pctldev, pin_id, &config);

Hm I would have preferred a fix actually checking the ret value,
but the debug show doesn't allow failing, and it's just for
debug anyway...

Patch applied.

Yours,
Linus Walleij
