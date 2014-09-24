Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaIXQS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:18:26 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:40625 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaIXQSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:18:25 -0400
Date: Wed, 24 Sep 2014 10:18:10 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH 2/2] tpm/tpm_ibmvtpm: Remove unnecessary
 casts
Message-ID: <20140924161810.GA8898@obsidianresearch.com>
References: <20140920072942.27c28768@kryten>
 <20140920073014.071007cc@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920073014.071007cc@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 07:30:14AM +1000, Anton Blanchard wrote:
> There is no need to cast from a void pointer to another pointer.

Looks reasonable to me:

Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> 
> Index: b/drivers/char/tpm/tpm_ibmvtpm.c
> ===================================================================
> +++ b/drivers/char/tpm/tpm_ibmvtpm.c
> @@ -65,7 +65,7 @@ static struct ibmvtpm_dev *ibmvtpm_get_d
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  
>  	BUG_ON(!chip);
> -	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> +	return TPM_VPRIV(chip);
>  }
>  
>  /**
> @@ -83,7 +83,7 @@ static int tpm_ibmvtpm_recv(struct tpm_c
>  	u16 len;
>  	int sig;
>  
> -	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> +	ibmvtpm = TPM_VPRIV(chip);
>  
>  	if (!ibmvtpm->rtce_buf) {
>  		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
> @@ -127,7 +127,7 @@ static int tpm_ibmvtpm_send(struct tpm_c
>  	u64 *word = (u64 *) &crq;
>  	int rc;
>  
> -	ibmvtpm = (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> +	ibmvtpm = TPM_VPRIV(chip);
>  
>  	if (!ibmvtpm->rtce_buf) {
>  		dev_err(ibmvtpm->dev, "ibmvtpm device is not ready\n");
> @@ -521,7 +521,7 @@ static void ibmvtpm_crq_process(struct i
>   **/
>  static irqreturn_t ibmvtpm_interrupt(int irq, void *vtpm_instance)
>  {
> -	struct ibmvtpm_dev *ibmvtpm = (struct ibmvtpm_dev *) vtpm_instance;
> +	struct ibmvtpm_dev *ibmvtpm = vtpm_instance;
>  	struct ibmvtpm_crq *crq;
>  
>  	/* while loop is needed for initial setup (get version and
> 
> Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
> Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
> Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
> Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
> http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

-- 
Jason Gunthorpe <jgunthorpe@obsidianresearch.com>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
