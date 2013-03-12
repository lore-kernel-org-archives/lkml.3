Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab3CLSEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:04:11 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:23616
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932470Ab3CLSEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:04:09 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz9371I542I1432I179cIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Topic: [PATCH 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Index: AQHOH0tpjy8GDvj/rE2LPkYB1MtjaJiiWHDw
Date: Tue, 12 Mar 2013 18:01:35 +0000
Message-ID: <da0b6d459785474b92f7bb1893f4a016@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363112959-30386-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1363112959-30386-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.116]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(13464002)(51704002)(377454001)(60444002)(80022001)(31966008)(46406002)(63696002)(56776001)(54316002)(59766001)(51856001)(23726001)(5343635001)(56816002)(50986001)(65816001)(4396001)(1511001)(44976002)(77982001)(47736001)(50466001)(74502001)(76482001)(79102001)(49866001)(66066001)(69226001)(33646001)(16676001)(6806001)(53806001)(46102001)(74662001)(47776003)(47976001)(47446002)(54356001)(20776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB010;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 078310077C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, March 12, 2013 2:29 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: hv: Add a new driver to support host initiated
> backup
> 
> This driver supports host initiated backup of the guest. On Windows guests,
> the host can generate application consistent backups using the Windows VSS
> framework. On Linux, we ensure that the backup will be file system consistent.
> This driver allows the host to initiate a  "Freeze" operation on all the mounted
> file systems in the guest. Once the mounted file systems in the guest are frozen,
> the host snapshots the guest's file systems. Once this is done, the guest's file
> systems are "thawed".
> 
> This driver has a user-level component (daemon) that invokes the appropriate
> operation on all the mounted file systems in response to the requests from
> the host. The duration for which the guest is frozen is very short - a few seconds.
> During this interval, the diff disk is comitted.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Greg,

Please drop this patch. I sent the wrong patch.

K. Y
> ---
>  drivers/hv/Makefile            |    2 +-
>  drivers/hv/hv_util.c           |   10 ++++++
>  include/linux/hyperv.h         |   69
> ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/connector.h |    5 ++-
>  4 files changed, 84 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
> index e6abfa0..0a74b56 100644
> --- a/drivers/hv/Makefile
> +++ b/drivers/hv/Makefile
> @@ -5,4 +5,4 @@ obj-$(CONFIG_HYPERV_BALLOON)	+= hv_balloon.o
>  hv_vmbus-y := vmbus_drv.o \
>  		 hv.o connection.o channel.o \
>  		 channel_mgmt.o ring_buffer.o
> -hv_utils-y := hv_util.o hv_kvp.o
> +hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 1d4cbd8..2f561c5 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -49,6 +49,12 @@ static struct hv_util_service util_kvp = {
>  	.util_deinit = hv_kvp_deinit,
>  };
> 
> +static struct hv_util_service util_vss = {
> +	.util_cb = hv_vss_onchannelcallback,
> +	.util_init = hv_vss_init,
> +	.util_deinit = hv_vss_deinit,
> +};
> +
>  static void perform_shutdown(struct work_struct *dummy)
>  {
>  	orderly_poweroff(true);
> @@ -339,6 +345,10 @@ static const struct hv_vmbus_device_id id_table[] = {
>  	{ HV_KVP_GUID,
>  	  .driver_data = (unsigned long)&util_kvp
>  	},
> +	/* VSS GUID */
> +	{ HV_VSS_GUID,
> +	  .driver_data = (unsigned long)&util_vss
> +	},
>  	{ },
>  };
> 
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index df77ba9..95d0850 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -27,6 +27,63 @@
> 
>  #include <linux/types.h>
> 
> +
> +/*
> + * Implementation of host controlled snapshot of the guest.
> + */
> +
> +#define VSS_OP_REGISTER 128
> +
> +enum hv_vss_op {
> +	VSS_OP_CREATE = 0,
> +	VSS_OP_DELETE,
> +	VSS_OP_HOT_BACKUP,
> +	VSS_OP_GET_DM_INFO,
> +	VSS_OP_BU_COMPLETE,
> +	/*
> +	 * Following operations are only supported with IC version >= 5.0
> +	 */
> +	VSS_OP_FREEZE, /* Freeze the file systems in the VM */
> +	VSS_OP_THAW, /* Unfreeze the file systems */
> +	VSS_OP_AUTO_RECOVER,
> +	VSS_OP_COUNT /* Number of operations, must be last */
> +};
> +
> +
> +/*
> + * Header for all VSS messages.
> + */
> +struct hv_vss_hdr {
> +	__u8 operation;
> +	__u8 reserved[7];
> +} __attribute__((packed));
> +
> +
> +/*
> + * Flag values for the hv_vss_check_feature. Linux supports only
> + * one value.
> + */
> +#define VSS_HBU_NO_AUTO_RECOVERY	0x00000005
> +
> +struct hv_vss_check_feature {
> +	__u32 flags;
> +} __attribute__((packed));
> +
> +struct hv_vss_check_dm_info {
> +	__u32 flags;
> +} __attribute__((packed));
> +
> +struct hv_vss_msg {
> +	union {
> +		struct hv_vss_hdr vss_hdr;
> +		int error;
> +	};
> +	union {
> +		struct hv_vss_check_feature vss_cf;
> +		struct hv_vss_check_dm_info dm_info;
> +	};
> +} __attribute__((packed));
> +
>  /*
>   * An implementation of HyperV key value pair (KVP) functionality for Linux.
>   *
> @@ -1253,6 +1310,14 @@ void vmbus_driver_unregister(struct hv_driver
> *hv_driver);
>  		}
> 
>  /*
> + * VSS (Backup/Restore) GUID
> + */
> +#define HV_VSS_GUID \
> +	.guid = { \
> +			0x29, 0x2e, 0xfa, 0x35, 0x23, 0xea, 0x36, 0x42, \
> +			0x96, 0xae, 0x3a, 0x6e, 0xba, 0xcb, 0xa4,  0x40 \
> +		}
> +/*
>   * Common header for Hyper-V ICs
>   */
> 
> @@ -1356,6 +1421,10 @@ int hv_kvp_init(struct hv_util_service *);
>  void hv_kvp_deinit(void);
>  void hv_kvp_onchannelcallback(void *);
> 
> +int hv_vss_init(struct hv_util_service *);
> +void hv_vss_deinit(void);
> +void hv_vss_onchannelcallback(void *);
> +
>  /*
>   * Negotiated version with the Host.
>   */
> diff --git a/include/uapi/linux/connector.h b/include/uapi/linux/connector.h
> index 8761a03..4cb2835 100644
> --- a/include/uapi/linux/connector.h
> +++ b/include/uapi/linux/connector.h
> @@ -44,8 +44,11 @@
>  #define CN_VAL_DRBD			0x1
>  #define CN_KVP_IDX			0x9	/* HyperV KVP */
>  #define CN_KVP_VAL			0x1	/* queries from the kernel */
> +#define CN_VSS_IDX			0xA     /* HyperV VSS */
> +#define CN_VSS_VAL			0x1     /* queries from the kernel */
> 
> -#define CN_NETLINK_USERS		10	/* Highest index + 1 */
> +
> +#define CN_NETLINK_USERS		11	/* Highest index + 1 */
> 
>  /*
>   * Maximum connector's message size.
> --
> 1.7.4.1
> 
> 


