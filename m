Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3C1Kne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:43:34 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46130 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3C1Knc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:43:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        rajagopal.venkat@linaro.org, davidb@codeaurora.org,
        ulf.hansson@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH v5 0/2] reentrancy in the common clk framework
Date: Thu, 28 Mar 2013 11:44:22 +0100
Message-ID: <1703638.PLNmMUvYmW@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1364445958-2999-1-git-send-email-mturquette@linaro.org>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org> <1364445958-2999-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wednesday 27 March 2013 21:45:56 Mike Turquette wrote:
> This fifth attempt at allowing calls to the clk api to reenter splits
> the last patch into two parts.  The first patch abstracts out the
> locking details into some helper functions and converts all of the
> direct calls to the mutex and spinlock api to use these helpers.
> 
> The second patch introduces the reentrancy logic into these helper
> functions.  Fundamentally the reentrancy logic hasn't changed since v4,
> but fixing casting bugs, removing unnecessary barriers and better design
> & beautification separate this approach from the last one.
> 
> Changes tested on top of the latest clk-next branch with an OMAP4430
> Panda board.
> 
> Mike Turquette (2):
>   clk: abstract locking out into helper functions
>   clk: allow reentrant calls into the clk framework
> 
>  drivers/clk/clk.c |  136 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 98 insertions(+), 38 deletions(-)

For the whole patch set,

Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

on a DM3730.

-- 
Regards,

Laurent Pinchart

