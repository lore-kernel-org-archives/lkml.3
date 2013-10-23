Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3JWIpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:45:22 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37940 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3JWIpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8TpMFSUqCePW6=Ef_6_w39goayhQZO-fnu4_QJ10wfnA@mail.gmail.com>
References: <CAPgLHd8TpMFSUqCePW6=Ef_6_w39goayhQZO-fnu4_QJ10wfnA@mail.gmail.com>
Date: Wed, 23 Oct 2013 10:45:18 +0200
Message-ID: <CACRpkdbHcCKAJko3RLsnyuDCR01g6kHLSobewj_QffwpRA+NZg@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: tb10x: fix the error handling in tb10x_pinctrl_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 4:55 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> This patch fix the error handling in tb10x_pinctrl_probe():
>  - devm_ioremap_resource() return ERR_PTR() and never return NULL
>  - remove the dev_err call to avoid redundant error message
>  - pinctrl_register() returns NULL not ERR_PTR()
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, patch applied!

Hm this seems to be an easy mistake to do. I have discussed
in the past whether we can make the compiler verify
error pointers semantically and warn on problems.

I don't know if that is achieveable though :-(

Yours,
Linus Walleij
