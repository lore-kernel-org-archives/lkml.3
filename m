Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3IMI4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:56:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50559 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab3IMI4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:56:17 -0400
Date: Fri, 13 Sep 2013 09:56:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: "steve.glendinning@shawell.net" <steve.glendinning@shawell.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davidb@quicinc.com
Subject: Re: [PATCH] net: smsc: remove deprecated IRQF_DISABLED
Message-ID: <20130913085607.GA20681@mudshark.cambridge.arm.com>
References: <1379046467-6900-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379046467-6900-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding David Brown]

On Fri, Sep 13, 2013 at 05:27:47AM +0100, Michael Opdenacker wrote:
> This patch proposes to remove the IRQF_DISABLED flag from
> code in drivers/net/ethernet/smsc/
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/net/ethernet/smsc/smc91x.h   | 2 +-
>  drivers/net/ethernet/smsc/smsc9420.c | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/smsc/smc91x.h b/drivers/net/ethernet/smsc/smc91x.h
> index 370e13d..5730fe2 100644
> --- a/drivers/net/ethernet/smsc/smc91x.h
> +++ b/drivers/net/ethernet/smsc/smc91x.h
> @@ -271,7 +271,7 @@ static inline void mcf_outsw(void *a, unsigned char *p, int l)
>  #define SMC_insw(a, r, p, l)	mcf_insw(a + r, p, l)
>  #define SMC_outsw(a, r, p, l)	mcf_outsw(a + r, p, l)
>  
> -#define SMC_IRQ_FLAGS		(IRQF_DISABLED)
> +#define SMC_IRQ_FLAGS		0

After this change, the only machine that defines the flags to anything other
than IRQF_TRIGGER_RISING is MSM, which uses IRQF_TRIGGER_HIGH. David: do
you actually need this? The irq_chip code under mach-msm doesn't seem to
distinguish between the two.

Will
