Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaFCRaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:30:35 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:41989
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751251AbaFCRad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:30:33 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Stephen Hemminger <stephen@networkplumber.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] hyper-v: make uuid_le const
Thread-Topic: [PATCH net-next] hyper-v: make uuid_le const
Thread-Index: AQHPf0HZHfNKsVU2C0eN64jc2AYdRJtfpC6w
Date: Tue, 3 Jun 2014 17:30:28 +0000
Message-ID: <04f86b9536044961bb702ecf554fc146@BL2PR03MB291.namprd03.prod.outlook.com>
References: <20140603083815.14688f8a@nehalam.linuxnetplumber.net>
In-Reply-To: <20140603083815.14688f8a@nehalam.linuxnetplumber.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.62]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 02318D10FB
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(199002)(189002)(377454003)(13464003)(54356999)(21056001)(50986999)(99396002)(99286001)(19580395003)(66066001)(80022001)(79102001)(4396001)(33646001)(19580405001)(83322001)(87936001)(85852003)(83072002)(1511001)(101416001)(74502001)(2656002)(20776003)(76576001)(81542001)(86362001)(81342001)(86612001)(74316001)(77982001)(74662001)(31966008)(77096999)(76482001)(46102001)(76176999)(92566001)(64706001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB292;H:BL2PR03MB291.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger [mailto:stephen@networkplumber.org]
> Sent: Tuesday, June 3, 2014 8:38 AM
> To: KY Srinivasan; Haiyang Zhang
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: [PATCH net-next] hyper-v: make uuid_le const
> 
> The uuid structure could be managed as a const in several places.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Thanks Stephen.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> 
> ---
> Patch against net-next because that is where most recent hyper-v related
> changes are.
> 
> 
> --- a/drivers/hv/channel_mgmt.c	2014-02-12 08:21:54.627887619 -0800
> +++ b/drivers/hv/channel_mgmt.c	2014-06-03 08:08:47.030901345 -0700
> @@ -365,7 +365,7 @@ static u32  next_vp;
>   * performance critical channels (IDE, SCSI and Network) will be uniformly
>   * distributed across all available CPUs.
>   */
> -static u32 get_vp_index(uuid_le *type_guid)
> +static u32 get_vp_index(const uuid_le *type_guid)
>  {
>  	u32 cur_cpu;
>  	int i;
> --- a/drivers/hv/vmbus_drv.c	2014-04-07 11:21:05.704486433 -0700
> +++ b/drivers/hv/vmbus_drv.c	2014-06-03 08:11:14.771854064 -0700
> @@ -435,7 +435,7 @@ static int vmbus_uevent(struct device *d
>  	return ret;
>  }
> 
> -static uuid_le null_guid;
> +static const uuid_le null_guid;
> 
>  static inline bool is_null_guid(const __u8 *guid)  { @@ -450,7 +450,7 @@
> static inline bool is_null_guid(const __
>   */
>  static const struct hv_vmbus_device_id *hv_vmbus_get_id(
>  					const struct hv_vmbus_device_id
> *id,
> -					__u8 *guid)
> +					const __u8 *guid)
>  {
>  	for (; !is_null_guid(id->guid); id++)
>  		if (!memcmp(&id->guid, guid, sizeof(uuid_le))) @@ -779,9
> +779,9 @@ EXPORT_SYMBOL_GPL(vmbus_driver_unregiste
>   * vmbus_device_create - Creates and registers a new child device
>   * on the vmbus.
>   */
> -struct hv_device *vmbus_device_create(uuid_le *type,
> -					    uuid_le *instance,
> -					    struct vmbus_channel *channel)
> +struct hv_device *vmbus_device_create(const uuid_le *type,
> +				      const uuid_le *instance,
> +				      struct vmbus_channel *channel)
>  {
>  	struct hv_device *child_device_obj;
> 
> --- a/drivers/hv/hyperv_vmbus.h	2014-04-07 11:21:05.704486433 -0700
> +++ b/drivers/hv/hyperv_vmbus.h	2014-06-03 08:27:12.618223800 -0700
> @@ -644,9 +644,9 @@ extern struct vmbus_connection vmbus_con
> 
>  /* General vmbus interface */
> 
> -struct hv_device *vmbus_device_create(uuid_le *type,
> -					 uuid_le *instance,
> -					 struct vmbus_channel *channel);
> +struct hv_device *vmbus_device_create(const uuid_le *type,
> +				      const uuid_le *instance,
> +				      struct vmbus_channel *channel);
> 
>  int vmbus_device_register(struct hv_device *child_device_obj);  void
> vmbus_device_unregister(struct hv_device *device_obj);
