Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaFIN6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:58:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:24308 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaFIN6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:58:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1002,1392192000"; 
   d="scan'208";a="552659425"
From: "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>
CC: "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] infiniband: hw: ipath: ipath_diag.c:  Cleaning up code
 that is not handled properly.
Thread-Topic: [PATCH] infiniband: hw: ipath: ipath_diag.c:  Cleaning up code
 that is not handled properly.
Thread-Index: AQHPgdwvFzIemVMCZ0WFIdvul6M50Zto0HKw
Date: Mon, 9 Jun 2014 13:57:38 +0000
Message-ID: <D2F193D21ECD8C45917AD3D5B26513301E43F7@CRSMSX101.amr.corp.intel.com>
References: <1402096136-9919-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1402096136-9919-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.18.205.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Rickard Strandqvist
> Sent: Friday, June 6, 2014 7:09 PM
> To: infinipath; Roland Dreier
> Cc: Rickard Strandqvist; Hefty, Sean; Hal Rosenstock; linux-
> rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] infiniband: hw: ipath: ipath_diag.c: Cleaning up code that is
> not handled properly.
> 
> None of the code is adapted to handle a struct ipath_diag_pkt.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/infiniband/hw/ipath/ipath_diag.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c
> b/drivers/infiniband/hw/ipath/ipath_diag.c
> index e2f9a51..39ba797 100644
> --- a/drivers/infiniband/hw/ipath/ipath_diag.c
> +++ b/drivers/infiniband/hw/ipath/ipath_diag.c
> @@ -327,7 +327,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,  {
>  	u32 __iomem *piobuf;
>  	u32 plen, pbufn, maxlen_reserve;
> -	struct ipath_diag_pkt odp;
>  	struct ipath_diag_xpkt dp;
>  	u32 *tmpbuf = NULL;
>  	struct ipath_devdata *dd;
> @@ -341,11 +340,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
>  			ret = -EFAULT;
>  			goto bail;
>  		}
> -	} else if (count == sizeof(odp)) {
> -		if (copy_from_user(&odp, data, sizeof(odp))) {
> -			ret = -EFAULT;
> -			goto bail;
> -		}
>  	} else {
>  		ret = -EINVAL;
>  		goto bail;
> --
> 1.7.10.4

Hi Rickard, 

Please see commit 7e6d3e5c70f13874fb06e6b67696ed90ce79bd48 in Roland's for-next branch. I added the missed support for using odp already.

Thanks
-Denny
