Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaDOTMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:12:55 -0400
Received: from void.printf.net ([89.145.121.20]:49020 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaDOTMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:12:54 -0400
From: Chris Ball <chris@printf.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: fix Venice2 VQMMC regulators
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
	<1397526163-20126-5-git-send-email-abrestic@chromium.org>
	<534D7AFD.7080807@wwwdotorg.org>
Date: Tue, 15 Apr 2014 20:12:48 +0100
In-Reply-To: <534D7AFD.7080807@wwwdotorg.org> (Stephen Warren's message of
	"Tue, 15 Apr 2014 12:31:25 -0600")
Message-ID: <864n1uv233.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Apr 15 2014, Stephen Warren wrote:
> Is there documentation re: what vmmc-supply and vqmmc-supply actually
> refer to? I looked a long while ago and couldn't find any, and didn't
> get an answer when I asked.
>
> Neither
> Documentation/devicetree/bindings/mmc/{mmc.txt,nvidia,tegra20-sdhci.txt}
> seem to say:-(

MMC cards use the same voltage for the VDD pin on the card and to pull
up the signal lines.  UHS SDHCI switches to using 1.8V vqmmc (signaling
voltage) and 3.3V vmmc (card supply voltage).

So the idea is to supply a vqmmc-supply if your board supports
ultra-high-speed modes on an SD 3.0 host, and a vmmc-supply if your
card power is controlled by a regulator.  I agree that this ought to
be in the bindings somewhere.

Thanks,

- Chris.
-- 
Chris Ball   <http://printf.net/>
