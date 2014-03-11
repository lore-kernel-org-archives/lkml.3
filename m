Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaCKKDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:03:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:11903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaCKKDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:03:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="496059337"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "trivial@kernel.org" <trivial@kernel.org>
Subject: RE: [PATCH 1/4] mei: Don't log an error when the MEI device is
 quirked off
Thread-Topic: [PATCH 1/4] mei: Don't log an error when the MEI device is
 quirked off
Thread-Index: AQHPOwBkI2Wy0FfIFUC2TJ5CUDIZwZrbqZmw
Date: Tue, 11 Mar 2014 10:03:24 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF8ED5D@HASMSX106.ger.corp.intel.com>
References: <cover.1394304585.git.luto@amacapital.net>
 <9bdf4f25e7c57bccd20d7470271b7e385aac270a.1394304585.git.luto@amacapital.net>
In-Reply-To: <9bdf4f25e7c57bccd20d7470271b7e385aac270a.1394304585.git.luto@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Saturday, March 08, 2014 20:58
> To: linux-kernel@vger.kernel.org
> Cc: trivial@kernel.org; Andy Lutomirski; Winkler, Tomas
> Subject: [PATCH 1/4] mei: Don't log an error when the MEI device is quirked off
> 
> If an administrator wants to use MEI, they can search the logs for
> 'mei'.  Otherwise they don't need a glaring reminder that their
> hardware doesn't actually support MEI.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  drivers/misc/mei/pci-me.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
> index ddadd08..809021e 100644
> --- a/drivers/misc/mei/pci-me.c
> +++ b/drivers/misc/mei/pci-me.c
> @@ -127,7 +127,7 @@ static int mei_me_probe(struct pci_dev *pdev, const
> struct pci_device_id *ent)
> 
>  	if (!mei_me_quirk_probe(pdev, ent)) {
>  		err = -ENODEV;
> -		goto end;
> +		return err;  /* No point in logging an error. */
>  	}


I would like to have at least some info/debug message logged, 
the issue was discovered on specific DELL machines and there is a little worry  
that on some systems it can be false positive.

Thanks
Tomas

