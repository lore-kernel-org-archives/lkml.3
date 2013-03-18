Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3CRSev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:34:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37000 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab3CRSet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:34:49 -0400
Date: Mon, 18 Mar 2013 18:34:36 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCHv2 3/3] ARM: Work around faulty ISAR0 register in some
 Krait CPUs
Message-ID: <20130318183435.GD31193@mudshark.cambridge.arm.com>
References: <1363631337-13816-1-git-send-email-sboyd@codeaurora.org>
 <1363631337-13816-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363631337-13816-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 06:28:57PM +0000, Stephen Boyd wrote:
> From: Stepan Moskovchenko <stepanm@codeaurora.org>
> 
> Some early versions of the Krait CPU design incorrectly indicate
> that they only support the UDIV and SDIV instructions in Thumb
> mode when they actually support them in ARM and Thumb mode. It
> seems that these CPUs follow the DDI0406B ARM ARM which has two
> possible values for the divide instructions field, instead of the
> DDI0406C document which has three possible values.
> 
> Work around this problem by checking the MIDR against Krait CPUs
> with this faulty ISAR0 register and force the hwcaps to indicate
> support in both modes.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> [sboyd: Rewrote commit text to reflect real reasoning now that
> 	we autodetect udiv/sdiv]
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mm/proc-v7.S | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

Acked-by: Will Deacon <will.deacon@arm.com>

Will
