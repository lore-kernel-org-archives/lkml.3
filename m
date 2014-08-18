Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaHRNa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:30:27 -0400
Received: from [195.154.187.82] ([195.154.187.82]:57620 "EHLO ou.quest-ce.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaHRNaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:30:25 -0400
Message-ID: <1408368608.3030.4.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Date: Mon, 18 Aug 2014 15:30:08 +0200
In-Reply-To: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1408315225-16807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 92.90.20.119
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH] infiniband: hw: cxgb3: cxio_hal.c:  Cleaning up missing
 null-terminate after strncpy call
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le lundi 18 août 2014 à 00:40 +0200, Rickard Strandqvist a écrit :
> Added a guaranteed null-terminate after call to strncpy.
> 

Good catch. Do you have an automated way to catch such mistake ?

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/infiniband/hw/cxgb3/cxio_hal.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> index de1c61b4..5fc04e4 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
> +++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> @@ -933,6 +933,7 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
>  		netdev_p = rdev_p->t3cdev_p->lldev;
>  		strncpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
>  			T3_MAX_DEV_NAME_LEN);
> +		rdev_p->dev_name[T3_MAX_DEV_NAME_LEN - 1] = '\0';

Why not replacing this by

		strlcpy(rdev_p->dev_name, rdev_p->t3cdev_p->name,
			T3_MAX_DEV_NAME_LEN);

Regards.

-- 
Yann Droneaud
OPTEYA


