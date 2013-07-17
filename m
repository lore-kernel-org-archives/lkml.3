Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3GQMgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:36:13 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:17119
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754350Ab3GQMgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:36:12 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Id799hzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(377454003)(13464003)(199002)(189002)(51704005)(77982001)(4396001)(66066001)(51856001)(54316002)(69226001)(46102001)(47446002)(74316001)(74876001)(16406001)(65816001)(80022001)(1511001)(551934002)(56776001)(74662001)(56816003)(54356001)(76576001)(47736001)(74706001)(74502001)(59766001)(79102001)(53806001)(76796001)(49866001)(31966008)(77096001)(76786001)(33646001)(74366001)(50986001)(76482001)(63696002)(81542001)(47976001)(81342001)(83072001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:24.56.202.201;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation
 code for util services
Thread-Topic: [PATCH 1/1] Drivers: hv: util: Fix a bug in version
 negotiation code for util services
Thread-Index: AQHOd0UKrHFKHj6YF0aFkGvHNZstGZlo5XpA
Date: Wed, 17 Jul 2013 12:35:42 +0000
Message-ID: <39fe1ebc4d4d45488f30612bd942f3e1@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1372786290-12641-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1372786290-12641-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.56.202.201]
x-forefront-prvs: 0910AAF391
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
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454003)(199002)(189002)(13464003)(51704005)(46102001)(80022001)(44976005)(33646001)(51856001)(47776003)(74316001)(53806001)(54356001)(76576001)(31966008)(49866001)(56776001)(59766001)(47446002)(74706001)(83072001)(77096001)(77982001)(76482001)(79102001)(54316002)(50466002)(56816003)(4396001)(74502001)(74876001)(74662001)(74366001)(76786001)(76796001)(1511001)(50986001)(46406003)(23726002)(47976001)(47736001)(81342001)(20776003)(551934002)(63696002)(16676001)(66066001)(6806004)(81542001)(69226001)(65816001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB043;H:TK5EX14HUBC105.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0910AAF391
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, July 02, 2013 1:32 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation code for util
> services
> 
> The current code picked the highest version advertised by the host. WS2012 R2
> has implemented a protocol version for KVP that is not compatible with prior
> protocol versions of KVP. Fix the bug in the current code by explicitly specifying
> the protocol version that the guest can support.

Greg,

Do you want me to resubmit this patch.

Regards,

K. Y
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/hv/channel_mgmt.c |   75 +++++++++++++++++++++++++++++++-------
> ------
>  drivers/hv/hv_kvp.c       |   24 ++++++++++++++-
>  drivers/hv/hv_snapshot.c  |   18 +++-------
>  drivers/hv/hv_util.c      |   21 +++++++++++--
>  include/linux/hyperv.h    |   10 +++++-
>  5 files changed, 109 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 0df7590..12ec8c8 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -48,30 +48,39 @@ struct vmbus_channel_message_table_entry {
>   * @negop is of type &struct icmsg_negotiate.
>   * Set up and fill in default negotiate response message.
>   *
> - * The max_fw_version specifies the maximum framework version that
> - * we can support and max _srv_version specifies the maximum service
> - * version we can support. A special value MAX_SRV_VER can be
> - * specified to indicate that we can handle the maximum version
> - * exposed by the host.
> + * The fw_version specifies the  framework version that
> + * we can support and srv_version specifies the service
> + * version we can support.
>   *
>   * Mainly used by Hyper-V drivers.
>   */
> -void vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
> +bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
>  				struct icmsg_negotiate *negop, u8 *buf,
> -				int max_fw_version, int max_srv_version)
> +				int fw_version, int srv_version)
>  {
> -	int icframe_vercnt;
> -	int icmsg_vercnt;
> +	int icframe_major, icframe_minor;
> +	int icmsg_major, icmsg_minor;
> +	int fw_major, fw_minor;
> +	int srv_major, srv_minor;
>  	int i;
> +	bool found_match = false;
> 
>  	icmsghdrp->icmsgsize = 0x10;
> +	fw_major = (fw_version >> 16);
> +	fw_minor = (fw_version & 0xFFFF);
> +
> +	srv_major = (srv_version >> 16);
> +	srv_minor = (srv_version & 0xFFFF);
> 
>  	negop = (struct icmsg_negotiate *)&buf[
>  		sizeof(struct vmbuspipe_hdr) +
>  		sizeof(struct icmsg_hdr)];
> 
> -	icframe_vercnt = negop->icframe_vercnt;
> -	icmsg_vercnt = negop->icmsg_vercnt;
> +	icframe_major = negop->icframe_vercnt;
> +	icframe_minor = 0;
> +
> +	icmsg_major = negop->icmsg_vercnt;
> +	icmsg_minor = 0;
> 
>  	/*
>  	 * Select the framework version number we will
> @@ -79,26 +88,48 @@ void vmbus_prep_negotiate_resp(struct icmsg_hdr
> *icmsghdrp,
>  	 */
> 
>  	for (i = 0; i < negop->icframe_vercnt; i++) {
> -		if (negop->icversion_data[i].major <= max_fw_version)
> -			icframe_vercnt = negop->icversion_data[i].major;
> +		if ((negop->icversion_data[i].major == fw_major) &&
> +		   (negop->icversion_data[i].minor == fw_minor)) {
> +			icframe_major = negop->icversion_data[i].major;
> +			icframe_minor = negop->icversion_data[i].minor;
> +			found_match = true;
> +		}
>  	}
> 
> +	if (!found_match)
> +		goto fw_error;
> +
> +	found_match = false;
> +
>  	for (i = negop->icframe_vercnt;
>  		 (i < negop->icframe_vercnt + negop->icmsg_vercnt); i++) {
> -		if (negop->icversion_data[i].major <= max_srv_version)
> -			icmsg_vercnt = negop->icversion_data[i].major;
> +		if ((negop->icversion_data[i].major == srv_major) &&
> +		   (negop->icversion_data[i].minor == srv_minor)) {
> +			icmsg_major = negop->icversion_data[i].major;
> +			icmsg_minor = negop->icversion_data[i].minor;
> +			found_match = true;
> +		}
>  	}
> 
>  	/*
> -	 * Respond with the maximum framework and service
> +	 * Respond with the framework and service
>  	 * version numbers we can support.
>  	 */
> -	negop->icframe_vercnt = 1;
> -	negop->icmsg_vercnt = 1;
> -	negop->icversion_data[0].major = icframe_vercnt;
> -	negop->icversion_data[0].minor = 0;
> -	negop->icversion_data[1].major = icmsg_vercnt;
> -	negop->icversion_data[1].minor = 0;
> +
> +fw_error:
> +	if (!found_match) {
> +		negop->icframe_vercnt = 0;
> +		negop->icmsg_vercnt = 0;
> +	} else {
> +		negop->icframe_vercnt = 1;
> +		negop->icmsg_vercnt = 1;
> +	}
> +
> +	negop->icversion_data[0].major = icframe_major;
> +	negop->icversion_data[0].minor = icframe_minor;
> +	negop->icversion_data[1].major = icmsg_major;
> +	negop->icversion_data[1].minor = icmsg_minor;
> +	return found_match;
>  }
> 
>  EXPORT_SYMBOL_GPL(vmbus_prep_negotiate_resp);
> diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
> index ed50e9e..5312720 100644
> --- a/drivers/hv/hv_kvp.c
> +++ b/drivers/hv/hv_kvp.c
> @@ -29,6 +29,16 @@
>  #include <linux/hyperv.h>
> 
> 
> +/*
> + * Pre win8 version numbers used in ws2008 and ws 2008 r2 (win7)
> + */
> +#define WIN7_SRV_MAJOR   3
> +#define WIN7_SRV_MINOR   0
> +#define WIN7_SRV_MAJOR_MINOR     (WIN7_SRV_MAJOR << 16 |
> WIN7_SRV_MINOR)
> +
> +#define WIN8_SRV_MAJOR   4
> +#define WIN8_SRV_MINOR   0
> +#define WIN8_SRV_MAJOR_MINOR     (WIN8_SRV_MAJOR << 16 |
> WIN8_SRV_MINOR)
> 
>  /*
>   * Global state maintained for transaction that is being processed.
> @@ -593,8 +603,19 @@ void hv_kvp_onchannelcallback(void *context)
>  			sizeof(struct vmbuspipe_hdr)];
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> +			/*
> +			 * We start with win8 version and if the host cannot
> +			 * support that we use the previous version.
> +			 */
> +			if (vmbus_prep_negotiate_resp(icmsghdrp, negop,
> +				 recv_buffer, UTIL_FW_MAJOR_MINOR,
> +				 WIN8_SRV_MAJOR_MINOR))
> +				goto done;
> +
>  			vmbus_prep_negotiate_resp(icmsghdrp, negop,
> -				 recv_buffer, MAX_SRV_VER, MAX_SRV_VER);
> +				 recv_buffer, UTIL_FW_MAJOR_MINOR,
> +				 WIN7_SRV_MAJOR_MINOR);
> +
>  		} else {
>  			kvp_msg = (struct hv_kvp_msg *)&recv_buffer[
>  				sizeof(struct vmbuspipe_hdr) +
> @@ -626,6 +647,7 @@ void hv_kvp_onchannelcallback(void *context)
>  			return;
> 
>  		}
> +done:
> 
>  		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
>  			| ICMSGHDRFLAG_RESPONSE;
> diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
> index 8ad5653..e4572f3 100644
> --- a/drivers/hv/hv_snapshot.c
> +++ b/drivers/hv/hv_snapshot.c
> @@ -24,6 +24,10 @@
>  #include <linux/workqueue.h>
>  #include <linux/hyperv.h>
> 
> +#define VSS_MAJOR  5
> +#define VSS_MINOR  0
> +#define VSS_MAJOR_MINOR    (VSS_MAJOR << 16 | VSS_MINOR)
> +
> 
> 
>  /*
> @@ -186,18 +190,8 @@ void hv_vss_onchannelcallback(void *context)
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
>  			vmbus_prep_negotiate_resp(icmsghdrp, negop,
> -				 recv_buffer, MAX_SRV_VER, MAX_SRV_VER);
> -			/*
> -			 * We currently negotiate the highest number the
> -			 * host has presented. If this version is not
> -			 * atleast 5.0, reject.
> -			 */
> -			negop = (struct icmsg_negotiate *)&recv_buffer[
> -				sizeof(struct vmbuspipe_hdr) +
> -				sizeof(struct icmsg_hdr)];
> -
> -			if (negop->icversion_data[1].major < 5)
> -				negop->icframe_vercnt = 0;
> +				 recv_buffer, UTIL_FW_MAJOR_MINOR,
> +				 VSS_MAJOR_MINOR);
>  		} else {
>  			vss_msg = (struct hv_vss_msg *)&recv_buffer[
>  				sizeof(struct vmbuspipe_hdr) +
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 2f561c5..c16164d 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -28,6 +28,18 @@
>  #include <linux/reboot.h>
>  #include <linux/hyperv.h>
> 
> +#define SHUTDOWN_MAJOR	3
> +#define SHUTDOWN_MINOR  0
> +#define SHUTDOWN_MAJOR_MINOR	(SHUTDOWN_MAJOR << 16 |
> SHUTDOWN_MINOR)
> +
> +#define TIMESYNCH_MAJOR	3
> +#define TIMESYNCH_MINOR 0
> +#define TIMESYNCH_MAJOR_MINOR	(TIMESYNCH_MAJOR << 16 |
> TIMESYNCH_MINOR)
> +
> +#define HEARTBEAT_MAJOR	3
> +#define HEARTBEAT_MINOR 0
> +#define HEARTBEAT_MAJOR_MINOR	(HEARTBEAT_MAJOR << 16 |
> HEARTBEAT_MINOR)
> +
>  static void shutdown_onchannelcallback(void *context);
>  static struct hv_util_service util_shutdown = {
>  	.util_cb = shutdown_onchannelcallback,
> @@ -87,7 +99,8 @@ static void shutdown_onchannelcallback(void *context)
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
>  			vmbus_prep_negotiate_resp(icmsghdrp, negop,
> -					shut_txf_buf, MAX_SRV_VER,
> MAX_SRV_VER);
> +					shut_txf_buf, UTIL_FW_MAJOR_MINOR,
> +					SHUTDOWN_MAJOR_MINOR);
>  		} else {
>  			shutdown_msg =
>  				(struct shutdown_msg_data *)&shut_txf_buf[
> @@ -213,7 +226,8 @@ static void timesync_onchannelcallback(void *context)
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
>  			vmbus_prep_negotiate_resp(icmsghdrp, NULL,
> time_txf_buf,
> -						MAX_SRV_VER, MAX_SRV_VER);
> +						UTIL_FW_MAJOR_MINOR,
> +						TIMESYNCH_MAJOR_MINOR);
>  		} else {
>  			timedatap = (struct ictimesync_data *)&time_txf_buf[
>  				sizeof(struct vmbuspipe_hdr) +
> @@ -253,7 +267,8 @@ static void heartbeat_onchannelcallback(void *context)
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
>  			vmbus_prep_negotiate_resp(icmsghdrp, NULL,
> -				hbeat_txf_buf, MAX_SRV_VER, MAX_SRV_VER);
> +				hbeat_txf_buf, UTIL_FW_MAJOR_MINOR,
> +				HEARTBEAT_MAJOR_MINOR);
>  		} else {
>  			heartbeat_msg =
>  				(struct heartbeat_msg_data *)&hbeat_txf_buf[
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index fae8bac..4994907 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -27,6 +27,14 @@
> 
>  #include <linux/types.h>
> 
> +/*
> + * Framework version for util services.
> + */
> +
> +#define UTIL_FW_MAJOR  3
> +#define UTIL_FW_MINOR  0
> +#define UTIL_FW_MAJOR_MINOR     (UTIL_FW_MAJOR << 16 |
> UTIL_FW_MINOR)
> +
> 
>  /*
>   * Implementation of host controlled snapshot of the guest.
> @@ -1494,7 +1502,7 @@ struct hyperv_service_callback {
>  };
> 
>  #define MAX_SRV_VER	0x7ffffff
> -extern void vmbus_prep_negotiate_resp(struct icmsg_hdr *,
> +extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *,
>  					struct icmsg_negotiate *, u8 *, int,
>  					int);
> 
> --
> 1.7.4.1
> 
> 


