Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaE3Bya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:54:30 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:54603 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaE3By2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <1401307872-23190-1-git-send-email-sboyd@codeaurora.org>
References: <1401307872-23190-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 29 May 2014 20:54:27 -0500
X-Google-Sender-Auth: Ev9TcuL395DFPXxcAxaCjLGZ2ns
Message-ID: <CAGo_u6oH_LbZwjXoMziqZp5Wg3KfEcXE5Wg0Kcmqei1EPGivfg@mail.gmail.com>
Subject: Re: [PATCH] net: ks8851: Don't use regulator_get_optional()
From: Nishanth Menon <nm@ti.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "David S . Miller" <davem@davemloft.net>, linux-arm-msm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        netdev@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 3:11 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> We shouldn't be using regulator_get_optional() here. These
> regulators are always present as part of the physical design and
> there isn't any way to use an internal regulator or change the
> source of the reference voltage via software. Given that the only
> users of this driver in the kernel are DT based, this change
> should be transparent to them even if they don't specify any
> supplies because the regulator framework will insert dummy
> supplies as needed.
>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Reviewed-and-Tested-by: Nishanth Menon <nm@ti.com>

SDP2430: with next-20140529:
before patch: https://github.com/nmenon/kernel-test-logs/blob/next-20140529/omap2plus_defconfig/sdp2430.txt

After patch: http://slexy.org/raw/s21sryFhAx
Looks good.
---
Regards,
Nishanth Menon
