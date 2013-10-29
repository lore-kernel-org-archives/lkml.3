Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3J2LpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:45:12 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:40780 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3J2LpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <1383043819-9123-1-git-send-email-tushar.behera@linaro.org>
References: <1383043819-9123-1-git-send-email-tushar.behera@linaro.org>
Date: Tue, 29 Oct 2013 17:15:10 +0530
Message-ID: <CAHbNUh1aKjkAx3xSHPeOdHH_8C6f64x6OTn_vtn_hj=TDORhBA@mail.gmail.com>
Subject: Re: [PATCH] clk: Zero-initialize memory for new clock in devm_clk_register
From: Tushar Behera <tushar.behera@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: mturquette <mturquette@linaro.org>, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2013 16:20, Tushar Behera <tushar.behera@linaro.org> wrote:
> Earlier to commit 64c862a839a8 ("devres: add kernel standard devm_k.alloc
> functions") devres_alloc API used to zero-initialize the devres
> allocated object, but now only the devres header is zero-initialized.
>
> Since clk_register zero-initializes the memory while allocating for
> a new clock, passing explicit flag __GFP_ZERO to devres_alloc in
> devm_clk_register to match the behaviour.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---

Please ignore this patch. Kevin Hilman already has got a nicer patch
[1] that fixes this problem at a generic level.

[1] https://lkml.org/lkml/2013/10/19/5

-- 
Tushar Behera
