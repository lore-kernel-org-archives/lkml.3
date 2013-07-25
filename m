Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3GYMpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:45:54 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:40505
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674Ab3GYMpw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:45:52 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC104.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(377454003)(199002)(189002)(51704005)(13464003)(74502001)(53806001)(76482001)(50986001)(56816003)(81542001)(47976001)(80022001)(74366001)(33646001)(4396001)(76786001)(54356001)(77096001)(19580405001)(47446002)(54316002)(65816001)(74662001)(49866001)(79102001)(83072001)(69226001)(16406001)(83322001)(76796001)(76576001)(19580395003)(51856001)(46102001)(66066001)(63696002)(74706001)(77982001)(59766001)(47736001)(74316001)(31966008)(56776001)(81342001)(74876001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: remove HV_DRV_VERSION
Thread-Topic: [PATCH] Drivers: hv: remove HV_DRV_VERSION
Thread-Index: AQHOXE8x4taQvJKyL0KIqc/Iu67A7Zl1rJwA
Date: Thu, 25 Jul 2013 12:29:59 +0000
Message-ID: <7397849146654b9dadf8fb85a3807a32@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1369819747-6218-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1369819747-6218-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0918748D70
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Wednesday, May 29, 2013 5:29 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH] Drivers: hv: remove HV_DRV_VERSION
> 
> Remove HV_DRV_VERSION, it has no meaning for upstream drivers.
> 
> Initially it was supposed to show the "Linux Integration Services"
> version, now it is not in sync anymore with the out-of-tree drivers
> available from the MSFT website.
> 
> The only place where a version string is still required is the KVP
> command "IntegrationServicesVersion" which is handled by
> tools/hv/hv_kvp_daemon.c. To satisfy such KVP request from the host pass
> the current string to the daemon during KVP userland registration.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hid/hid-hyperv.c        |  1 -
>  drivers/hv/hv_balloon.c         |  1 -
>  drivers/hv/hv_kvp.c             |  2 ++
>  drivers/hv/hv_util.c            |  1 -
>  drivers/hv/vmbus_drv.c          |  1 -
>  drivers/net/hyperv/netvsc_drv.c |  2 --
>  drivers/scsi/storvsc_drv.c      |  1 -
>  drivers/video/hyperv_fb.c       |  1 -
>  include/linux/hyperv.h          | 21 ---------------------
>  9 files changed, 2 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> index aa3fec0..05f3e96 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -592,6 +592,5 @@ static void __exit mousevsc_exit(void)
>  }
> 
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(HV_DRV_VERSION);
>  module_init(mousevsc_init);
>  module_exit(mousevsc_exit);
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 4c605c7..c4b50a5 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -1521,5 +1521,4 @@ static int __init init_balloon_drv(void)
>  module_init(init_balloon_drv);
> 
>  MODULE_DESCRIPTION("Hyper-V Balloon");
> -MODULE_VERSION(HV_DRV_VERSION);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
> index ed50e9e..296c16e 100644
> --- a/drivers/hv/hv_kvp.c
> +++ b/drivers/hv/hv_kvp.c
> @@ -76,7 +76,9 @@ static u8 *recv_buffer;
>  /*
>   * Register the kernel component with the user-level daemon.
>   * As part of this registration, pass the LIC version number.
> + * This number has no meaning, it satisfies the registration protocol.
>   */
> +#define HV_DRV_VERSION           "3.1"
> 
>  static void
>  kvp_register(int reg_value)
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 2f561c5..c59cc8b 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -380,5 +380,4 @@ module_init(init_hyperv_utils);
>  module_exit(exit_hyperv_utils);
> 
>  MODULE_DESCRIPTION("Hyper-V Utilities");
> -MODULE_VERSION(HV_DRV_VERSION);
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index bf421e0..7ef9585 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -812,7 +812,6 @@ static void __exit vmbus_exit(void)
> 
> 
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(HV_DRV_VERSION);
> 
>  subsys_initcall(hv_acpi_init);
>  module_exit(vmbus_exit);
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 088c554..e50ca64 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -303,7 +303,6 @@ static void netvsc_get_drvinfo(struct net_device *net,
>  			       struct ethtool_drvinfo *info)
>  {
>  	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> -	strlcpy(info->version, HV_DRV_VERSION, sizeof(info->version));
>  	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
>  }
> 
> @@ -526,7 +525,6 @@ static int __init netvsc_drv_init(void)
>  }
> 
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(HV_DRV_VERSION);
>  MODULE_DESCRIPTION("Microsoft Hyper-V network driver");
> 
>  module_init(netvsc_drv_init);
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 16a3a0c..1a720cf 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1610,7 +1610,6 @@ static void __exit storvsc_drv_exit(void)
>  }
> 
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(HV_DRV_VERSION);
>  MODULE_DESCRIPTION("Microsoft Hyper-V virtual storage driver");
>  module_init(storvsc_drv_init);
>  module_exit(storvsc_drv_exit);
> diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
> index d4d2c5f..8ac99b8 100644
> --- a/drivers/video/hyperv_fb.c
> +++ b/drivers/video/hyperv_fb.c
> @@ -825,5 +825,4 @@ module_init(hvfb_drv_init);
>  module_exit(hvfb_drv_exit);
> 
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(HV_DRV_VERSION);
>  MODULE_DESCRIPTION("Microsoft Hyper-V Synthetic Video Frame Buffer
> Driver");
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index c255984..e294ad7 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -455,27 +455,6 @@ hv_get_ringbuffer_availbytes(struct
> hv_ring_buffer_info *rbi,
>  	*read = dsize - *write;
>  }
> 
> -
> -/*
> - * We use the same version numbering for all Hyper-V modules.
> - *
> - * Definition of versioning is as follows;
> - *
> - *	Major Number	Changes for these scenarios;
> - *			1.	When a new version of Windows Hyper-V
> - *				is released.
> - *			2.	A Major change has occurred in the
> - *				Linux IC's.
> - *			(For example the merge for the first time
> - *			into the kernel) Every time the Major Number
> - *			changes, the Revision number is reset to 0.
> - *	Minor Number	Changes when new functionality is added
> - *			to the Linux IC's that is not a bug fix.
> - *
> - * 3.1 - Added completed hv_utils driver. Shutdown/Heartbeat/Timesync
> - */
> -#define HV_DRV_VERSION           "3.1"
> -
>  /*
>   * VMBUS version is 32 bit entity broken up into
>   * two 16 bit quantities: major_number. minor_number.
> 



