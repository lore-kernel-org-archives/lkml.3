Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaBMMQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:16:18 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:59158 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaBMMQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:16:16 -0500
MIME-Version: 1.0
In-Reply-To: <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
	<1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
Date: Thu, 13 Feb 2014 17:46:15 +0530
Message-ID: <CAKew6eWcwVm1EAUAdFu48y_O5puu+eGvGW3k6923MdXfMa3UAw@mail.gmail.com>
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14 regulators
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 13, 2014 at 2:44 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> S2MPS11/S2MPS14 regulators support different modes of operation:
>  - Always off;
>  - On/Off controlled by pin/GPIO (PWREN/LDOEN/EMMCEN);
>  - Always on;
> This is very similar to S5M8767 regulator driver which also supports
> opmodes (although S5M8767 have also low-power mode).
>
> This patch adds parsing the operation mode from DTS by reading a
> "op_mode" property from regulator child node.
>

First thing since "op_mode" is not generic property, I think it should
be appended with some driver specific prefix.

But IMHO its quite generic property used and required by many other
PMICs(almost all used by Samsung).
I would like to use this opportunity to discuss about adding it as
generic regulator constraint(as initial_mode)
by providing a default mapping of generic Regulator operating
modes(kernel specific) to operating modes supported by hardware in
regulator driver itself.

Regards,
Yadwinder
