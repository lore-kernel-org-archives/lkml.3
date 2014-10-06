Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaJFTUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:20:22 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:24801 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaJFTUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:20:19 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Fabian Frederick <fabf@skynet.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ISS StorageDev <iss_storagedev@hp.com>
Subject: RE: [PATCH 4/7 linux-next] cpqarray: remove deprecated IRQF_DISABLED
Thread-Topic: [PATCH 4/7 linux-next] cpqarray: remove deprecated
 IRQF_DISABLED
Thread-Index: AQHP4XtW6NaI8huerUmoksX4F9I6lpwjcQQw
Date: Mon, 6 Oct 2014 19:19:38 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CD82A4@G4W3202.americas.hpqcorp.net>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
 <1412609755-28627-5-git-send-email-fabf@skynet.be>
In-Reply-To: <1412609755-28627-5-git-send-email-fabf@skynet.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.192.236]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Fabian Frederick [mailto:fabf@skynet.be]
> Sent: Monday, October 06, 2014 10:36 AM
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman; Fabian Frederick; ISS StorageDev
> Subject: [PATCH 4/7 linux-next] cpqarray: remove deprecated
> IRQF_DISABLED
> 
> See include/linux/interrupt.h:
> "This flag is a NOOP and scheduled to be removed"
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/block/cpqarray.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
> index 2b94403..370721e 100644
> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -406,7 +406,7 @@ static int cpqarray_register_ctlr(int i, struct
> pci_dev *pdev)
>  	}
>  	hba[i]->access.set_intr_mask(hba[i], 0);
>  	if (request_irq(hba[i]->intr, do_ida_intr,
> -		IRQF_DISABLED|IRQF_SHARED, hba[i]->devname, hba[i]))
> +		IRQF_SHARED, hba[i]->devname, hba[i]))
>  	{
>  		printk(KERN_ERR "cpqarray: Unable to get irq %d for %s\n",
>  				hba[i]->intr, hba[i]->devname);
> --
> 1.9.3

Although we're awaiting resolution of MAINTAINERS updates for that
driver, this change was already made to cciss and hpsa several years
ago and seems fine here too.

Acked-by: Robert Elliott <elliott@hp.com>

