Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3IWOL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:11:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:42609 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab3IWOL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,962,1371106800"; 
   d="scan'208";a="382240754"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        intel-linux-scu <intel-linux-scu@intel.com>
Subject: RE: [PATCH 14/19] scsi: Change variable type to bool
Thread-Topic: [PATCH 14/19] scsi: Change variable type to bool
Thread-Index: AQHOtxq4GKpqGu8cRkWJKQ3oRL0l3JnTXYYw
Date: Mon, 23 Sep 2013 14:11:04 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A5EF079@IRSMSX105.ger.corp.intel.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
 <43e0f3a4fb62473e9bdd308a8dc4490f@fmsmsx104.amr.corp.intel.com>
In-Reply-To: <43e0f3a4fb62473e9bdd308a8dc4490f@fmsmsx104.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 22, 2013 12:28 AM Peter Senna Tschudin <peter.senna@gmail.com> wrote:
> 
> The variable success is only assigned the values true and false.
> Change its type to bool.
> 
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> @exists@
> type T;
> identifier b;
> @@
> - T
> + bool
>   b = ...;
>   ... when any
>   b = \(true\|false\)
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/scsi/isci/port.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
> index 13098b0..26f8e5c 100644
> --- a/drivers/scsi/isci/port.c
> +++ b/drivers/scsi/isci/port.c
> @@ -174,7 +174,7 @@ static void isci_port_link_up(struct isci_host *isci_host,
>  {
>  	unsigned long flags;
>  	struct sci_port_properties properties;
> -	unsigned long success = true;
> +	bool success = true;
> 
>  	dev_dbg(&isci_host->pdev->dev,
>  		"%s: isci_port = %p\n",
> --
> 1.8.3.1

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

