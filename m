Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210AbaLBTWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:22:44 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:39266 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaLBTWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:42 -0500
From: Ashley Lai <ashley@ashleylai.com>
X-Google-Original-From: Ashley Lai <alai@ant>
Date: Tue, 2 Dec 2014 13:22:35 -0600 (CST)
To: Anton Blanchard <anton@samba.org>
cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if
 driver_data is bad
In-Reply-To: <20140920072942.27c28768@kryten>
Message-ID: <alpine.DEB.2.10.1412021307180.15589@ant>
References: <20140920072942.27c28768@kryten>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -63,9 +63,9 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
> static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device *dev)
> {
> 	struct tpm_chip *chip = dev_get_drvdata(dev);
> -	if (chip)
> -		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> -	return NULL;
> +
> +	BUG_ON(!chip);

With the recent patch from Vicky, it is possible to have a NULL value for 
chip which will trigger a false positive for BUG_ON(!chip).

> +	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
> }
>
> /**
>
