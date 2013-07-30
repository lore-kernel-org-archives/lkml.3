Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3G3Mkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:40:52 -0400
Received: from void.printf.net ([89.145.121.20]:50807 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab3G3Mki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] Optional regulator support
References: <20130730114502.GQ9858@sirena.org.uk>
Date: Tue, 30 Jul 2013 13:40:28 +0100
In-Reply-To: <20130730114502.GQ9858@sirena.org.uk> (Mark Brown's message of
	"Tue, 30 Jul 2013 12:45:02 +0100")
Message-ID: <864nbcte4j.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 30 2013, Mark Brown wrote:
> This patch series adds a variant of regulator_get() which allows
> regulator consumers to tell the core that the supply they are requesting
> may genuinely be absent in the system.  The goal is to help address some
> of the problems with handling errors in regulator_get() in drivers that
> are newly converted to the regulator API by allowing the core to provide
> stub regulators for supplies that aren't hooked up without disrupting
> the operation of drivers like MMC drivers which may genuinely not have
> some of their supplies hooked up.
>
> Currently the code simply introduces a new API call with exactly the
> same implementation as regulator_get() so there should be zero impact
> from the series other than a slightly larger kernel.

Looks good:

Acked-by: Chris Ball <cjb@laptop.org>

> Right now all the MMC users are converted over as-is, though it does
> look like drivers such as sdhci really ought to be insisting on having a
> regulator for VMMC in the same way that the MMC core helper does (and
> indeed in that case it looks like it ought to be converted over to the
> core code).

I didn't follow this part -- I don't think the MMC core insists on a
VMMC regulator, and I don't think sdhci should either, because e.g.
an x86 laptop isn't going to have one.  What am I missing?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
