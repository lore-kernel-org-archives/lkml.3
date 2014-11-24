Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaKXPSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:18:48 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42577 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaKXPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:18:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a2-54734c5321ec
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
Date: Mon, 24 Nov 2014 16:18:30 +0100
Message-id: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xa7rBPsUhBp33zSzarhxktzj6u8Di
	9QtDi/7Hr5ktnm5+zGSx6fE1VovLu+awWcw4v4/J4umEi2wWh9+0s1qs2vWH0YHb4+/z6ywe
	O2fdZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXxtQJj5gKnrNV
	zJ7VwNrAuJ61i5GTQ0LARGLRzuVQtpjEhXvr2boYuTiEBJYySsye8ZUdwuljkpjTuIkRpIpN
	wFhi8/IlYFUiAtOYJf6sOM4OkmAWMJT4+e4PmC0s4C0x49h7NhCbRUBV4v6iSWDNvAJuEjMf
	zmSGWCcncfLYZNYJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE15cdjIuPWR1i
	FOBgVOLh/dFTGCLEmlhWXJl7iFGCg1lJhLfbqzhEiDclsbIqtSg/vqg0J7X4ECMTB6dUA6OY
	7XHD5Kyb92beLuVg93FaeNjR6q5FfcfR1R+XnPDSDF2ifYIv50dy2Nbeu+1iXk6u3F/CAyq4
	Fwmnd0qZ1p9znCXtWKbBH6byvm2L/Z6tDPOTEy1eS3kHhG3vV4quCuBc9buzx/2Cx/mjOici
	ajb9DbCJ+D/j+OusykV8TRsOF/xPST95X4mlOCPRUIu5qDgRACNlpT0NAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is initial idea to solve dependency between AudioSS clocks
and main clock controller on Exynos platform.

This solves boot failure of Peach Pi/Pit and Arndale Octa [1].

It is only RFC/proof of concept because I would like to hear whether
this is good direction to solve this particular issue (especially that
it touches main clk api).


[1] http://www.spinics.net/lists/linux-samsung-soc/msg39331.html

Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (2):
  clk: Allow overriding generic ops for clocks
  clk: samsung: Fix clock disable failure because domain being gated

 drivers/clk/clk-gate.c                 | 16 ++++++--
 drivers/clk/samsung/clk-exynos-audss.c | 69 +++++++++++++++++++++++++++-------
 include/linux/clk-provider.h           |  5 +++
 3 files changed, 74 insertions(+), 16 deletions(-)

-- 
1.9.1

