Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3CLC4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:56:25 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:39391
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246Ab3CLC4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:56:22 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add
 functionality
Thread-Topic: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add
 functionality
Thread-Index: AQHOHEbCmE27OfNng0mCdOHOBfNQ/ZihYA1A
Date: Tue, 12 Mar 2013 02:54:23 +0000
Message-ID: <924741bf41f14975af2f8f52b3251730@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1362780945-9796-1-git-send-email-kys@microsoft.com>
 <1362780973-9837-1-git-send-email-kys@microsoft.com>
 <1362780973-9837-5-git-send-email-kys@microsoft.com>
In-Reply-To: <1362780973-9837-5-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.156.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(377454001)(51704002)(199002)(13464002)(50986001)(1511001)(6806001)(56816002)(74502001)(54356001)(33646001)(79102001)(54316002)(80022001)(50466001)(47736001)(23726001)(5343635001)(77982001)(49866001)(51856001)(47976001)(56776001)(59766001)(46102001)(53806001)(31966008)(65816001)(20776003)(74662001)(16676001)(44976002)(46406002)(69226001)(47446002)(76482001)(4396001)(63696002)(47776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB025;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 078310077C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Friday, March 08, 2013 5:16 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: KY Srinivasan
> Subject: [PATCH 5/6] Drivers: hv: balloon: Implement hot-add functionality
> 
> Implement the memory hot-add functionality. With this, Linux guests can fully
> participate in the Dynamic Memory protocol implemented in the Windows hosts.

Greg,

I forgot to modify the Kconfig file to include the new dependency of the balloon driver on
MEMORY_HOTPLUG. Should I send a separate patch for  Kconfig, or resend this one patch
with the Kconfig changes folded in. Or, do you want me to resend the whole series.

Regards,

K. Y
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/hv/hv_balloon.c |  393
> ++++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 372 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> index 4743db9..232120d 100644
> --- a/drivers/hv/hv_balloon.c
> +++ b/drivers/hv/hv_balloon.c
> @@ -412,6 +412,27 @@ struct dm_info_msg {
>   * End protocol definitions.
>   */
> 
> +/*
> + * State to manage hot adding memory into the guest.
> + * The range start_pfn : end_pfn specifies the range
> + * that the host has asked us to hot add. The range
> + * start_pfn : ha_end_pfn specifies the range that we have
> + * currently hot added. We hot add in multiples of 128M
> + * chunks; it is possible that we may not be able to bring
> + * online all the pages in the region. The range
> + * covered_start_pfn : covered_end_pfn defines the pages that can
> + * be brough online.
> + */
> +
> +struct hv_hotadd_state {
> +	struct list_head list;
> +	unsigned long start_pfn;
> +	unsigned long covered_start_pfn;
> +	unsigned long covered_end_pfn;
> +	unsigned long ha_end_pfn;
> +	unsigned long end_pfn;
> +};
> +
>  struct balloon_state {
>  	__u32 num_pages;
>  	struct work_struct wrk;
> @@ -419,16 +440,17 @@ struct balloon_state {
> 
>  struct hot_add_wrk {
>  	union dm_mem_page_range ha_page_range;
> +	union dm_mem_page_range ha_region_range;
>  	struct work_struct wrk;
>  };
> 
> -static bool hot_add;
> +static bool hot_add = true;
>  static bool do_hot_add;
>  /*
>   * Delay reporting memory pressure by
>   * the specified number of seconds.
>   */
> -static uint pressure_report_delay = 30;
> +static uint pressure_report_delay = 45;
> 
>  module_param(hot_add, bool, (S_IRUGO | S_IWUSR));
>  MODULE_PARM_DESC(hot_add, "If set attempt memory hot_add");
> @@ -456,6 +478,7 @@ enum hv_dm_state {
>  static __u8 recv_buffer[PAGE_SIZE];
>  static __u8 *send_buffer;
>  #define PAGES_IN_2M	512
> +#define HA_CHUNK (32 * 1024)
> 
>  struct hv_dynmem_device {
>  	struct hv_device *dev;
> @@ -479,6 +502,17 @@ struct hv_dynmem_device {
>  	struct hot_add_wrk ha_wrk;
> 
>  	/*
> +	 * This state tracks if the host has specified a hot-add
> +	 * region.
> +	 */
> +	bool host_specified_ha_region;
> +
> +	/*
> +	 * State to synchronize hot-add.
> +	 */
> +	struct completion  ol_waitevent;
> +	bool ha_waiting;
> +	/*
>  	 * This thread handles hot-add
>  	 * requests from the host as well as notifying
>  	 * the host with regards to memory pressure in
> @@ -487,6 +521,11 @@ struct hv_dynmem_device {
>  	struct task_struct *thread;
> 
>  	/*
> +	 * A list of hot-add regions.
> +	 */
> +	struct list_head ha_region_list;
> +
> +	/*
>  	 * We start with the highest version we can support
>  	 * and downgrade based on the host; we save here the
>  	 * next version to try.
> @@ -496,35 +535,321 @@ struct hv_dynmem_device {
> 
>  static struct hv_dynmem_device dm_device;
> 
> -static void hot_add_req(struct work_struct *dummy)
> +void hv_bring_pgs_online(unsigned long start_pfn, unsigned long size)
>  {
> +	int i;
> 
> -	struct dm_hot_add_response resp;
> +	for (i = 0; i < size; i++) {
> +		struct page *pg;
> +		pg = pfn_to_page(start_pfn + i);
> +		__online_page_set_limits(pg);
> +		__online_page_increment_counters(pg);
> +		__online_page_free(pg);
> +	}
> +}
> +
> +static void hv_mem_hot_add(unsigned long start, unsigned long size,
> +				unsigned long pfn_count,
> +				struct hv_hotadd_state *has)
> +{
> +	int ret = 0;
> +	int i, nid, t;
> +	unsigned long start_pfn;
> +	unsigned long processed_pfn;
> +	unsigned long total_pfn = pfn_count;
> +
> +	for (i = 0; i < (size/HA_CHUNK); i++) {
> +		start_pfn = start + (i * HA_CHUNK);
> +		has->ha_end_pfn +=  HA_CHUNK;
> +
> +		if (total_pfn > HA_CHUNK) {
> +			processed_pfn = HA_CHUNK;
> +			total_pfn -= HA_CHUNK;
> +		} else {
> +			processed_pfn = total_pfn;
> +			total_pfn = 0;
> +		}
> +
> +		has->covered_end_pfn +=  processed_pfn;
> +
> +		init_completion(&dm_device.ol_waitevent);
> +		dm_device.ha_waiting = true;
> +
> +		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
> +		ret = add_memory(nid, PFN_PHYS((start_pfn)),
> +				(HA_CHUNK << PAGE_SHIFT));
> +
> +		if (ret) {
> +			pr_info("hot_add memory failed eror is %d\n", ret);
> +			has->ha_end_pfn -= HA_CHUNK;
> +			has->covered_end_pfn -=  processed_pfn;
> +			break;
> +		}
> +
> +		/*
> +		 * Wait for the memory block to be onlined.
> +		 */
> +		t = wait_for_completion_timeout(&dm_device.ol_waitevent,
> 5*HZ);
> +		if (t == 0) {
> +			pr_info("hot_add memory timedout\n");
> +			has->ha_end_pfn -= HA_CHUNK;
> +			has->covered_end_pfn -=  processed_pfn;
> +			break;
> +		}
> +
> +	}
> +
> +	return;
> +}
> +
> +static void hv_online_page(struct page *pg)
> +{
> +	struct list_head *cur;
> +	struct hv_hotadd_state *has;
> +	unsigned long cur_start_pgp;
> +	unsigned long cur_end_pgp;
> +
> +	if (dm_device.ha_waiting) {
> +		dm_device.ha_waiting = false;
> +		complete(&dm_device.ol_waitevent);
> +	}
> +
> +	list_for_each(cur, &dm_device.ha_region_list) {
> +		has = list_entry(cur, struct hv_hotadd_state, list);
> +		cur_start_pgp = (unsigned long)
> +				pfn_to_page(has->covered_start_pfn);
> +		cur_end_pgp = (unsigned long)pfn_to_page(has-
> >covered_end_pfn);
> +
> +		if (((unsigned long)pg >= cur_start_pgp) &&
> +			((unsigned long)pg < cur_end_pgp)) {
> +			/*
> +			 * This frame is currently backed; online the
> +			 * page.
> +			 */
> +			__online_page_set_limits(pg);
> +			__online_page_increment_counters(pg);
> +			__online_page_free(pg);
> +			has->covered_start_pfn++;
> +		}
> +	}
> +}
> 
> -	if (do_hot_add) {
> +static bool pfn_covered(unsigned long start_pfn, unsigned long pfn_cnt)
> +{
> +	struct list_head *cur;
> +	struct hv_hotadd_state *has;
> +	unsigned long residual, new_inc;
> +
> +	if (list_empty(&dm_device.ha_region_list))
> +		return false;
> +
> +	list_for_each(cur, &dm_device.ha_region_list) {
> +		has = list_entry(cur, struct hv_hotadd_state, list);
> +
> +		/*
> +		 * If the pfn range we are dealing with is not in the current
> +		 * "hot add block", move on.
> +		 */
> +		if ((start_pfn >= has->end_pfn))
> +			continue;
> +		/*
> +		 * If the current hot add-request extends beyond
> +		 * our current limit; extend it.
> +		 */
> +		if ((start_pfn + pfn_cnt) > has->end_pfn) {
> +			residual = (start_pfn + pfn_cnt - has->end_pfn);
> +			/*
> +			 * Extend the region by multiples of HA_CHUNK.
> +			 */
> +			new_inc = (residual / HA_CHUNK) * HA_CHUNK;
> +			if (residual % HA_CHUNK)
> +				new_inc += HA_CHUNK;
> 
> -		pr_info("Memory hot add not supported\n");
> +			has->end_pfn += new_inc;
> +		}
> 
>  		/*
> -		 * Currently we do not support hot add.
> -		 * Just fail the request.
> +		 * If the current start pfn is not where the covered_end
> +		 * is, update it.
>  		 */
> +
> +		if (has->covered_end_pfn != start_pfn) {
> +			has->covered_end_pfn = start_pfn;
> +			has->covered_start_pfn = start_pfn;
> +		}
> +		return true;
> +
>  	}
> 
> +	return false;
> +}
> +
> +static unsigned long handle_pg_range(unsigned long pg_start,
> +					unsigned long pg_count)
> +{
> +	unsigned long start_pfn = pg_start;
> +	unsigned long pfn_cnt = pg_count;
> +	unsigned long size;
> +	struct list_head *cur;
> +	struct hv_hotadd_state *has;
> +	unsigned long pgs_ol = 0;
> +	unsigned long old_covered_state;
> +
> +	if (list_empty(&dm_device.ha_region_list))
> +		return 0;
> +
> +	list_for_each(cur, &dm_device.ha_region_list) {
> +		has = list_entry(cur, struct hv_hotadd_state, list);
> +
> +		/*
> +		 * If the pfn range we are dealing with is not in the current
> +		 * "hot add block", move on.
> +		 */
> +		if ((start_pfn >= has->end_pfn))
> +			continue;
> +
> +		old_covered_state = has->covered_end_pfn;
> +
> +		if (start_pfn < has->ha_end_pfn) {
> +			/*
> +			 * This is the case where we are backing pages
> +			 * in an already hot added region. Bring
> +			 * these pages online first.
> +			 */
> +			pgs_ol = has->ha_end_pfn - start_pfn;
> +			if (pgs_ol > pfn_cnt)
> +				pgs_ol = pfn_cnt;
> +			hv_bring_pgs_online(start_pfn, pgs_ol);
> +			has->covered_end_pfn +=  pgs_ol;
> +			has->covered_start_pfn +=  pgs_ol;
> +			pfn_cnt -= pgs_ol;
> +		}
> +
> +		if ((has->ha_end_pfn < has->end_pfn) && (pfn_cnt > 0)) {
> +			/*
> +			 * We have some residual hot add range
> +			 * that needs to be hot added; hot add
> +			 * it now. Hot add a multiple of
> +			 * of HA_CHUNK that fully covers the pages
> +			 * we have.
> +			 */
> +			size = (has->end_pfn - has->ha_end_pfn);
> +			if (pfn_cnt <= size) {
> +				size = ((pfn_cnt / HA_CHUNK) * HA_CHUNK);
> +				if (pfn_cnt % HA_CHUNK)
> +					size += HA_CHUNK;
> +			} else {
> +				pfn_cnt = size;
> +			}
> +			hv_mem_hot_add(has->ha_end_pfn, size, pfn_cnt, has);
> +		}
> +		/*
> +		 * If we managed to online any pages that were given to us,
> +		 * we declare success.
> +		 */
> +		return has->covered_end_pfn - old_covered_state;
> +
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long process_hot_add(unsigned long pg_start,
> +					unsigned long pfn_cnt,
> +					unsigned long rg_start,
> +					unsigned long rg_size)
> +{
> +	struct hv_hotadd_state *ha_region = NULL;
> +
> +	if (pfn_cnt == 0)
> +		return 0;
> +
> +	if (!dm_device.host_specified_ha_region)
> +		if (pfn_covered(pg_start, pfn_cnt))
> +			goto do_pg_range;
> +
> +	/*
> +	 * If the host has specified a hot-add range; deal with it first.
> +	 */
> +
> +	if ((rg_size != 0) && (!dm_device.host_specified_ha_region)) {
> +		ha_region = kzalloc(sizeof(struct hv_hotadd_state),
> GFP_KERNEL);
> +		if (!ha_region)
> +			return 0;
> +
> +		INIT_LIST_HEAD(&ha_region->list);
> +
> +		list_add_tail(&ha_region->list, &dm_device.ha_region_list);
> +		ha_region->start_pfn = rg_start;
> +		ha_region->ha_end_pfn = rg_start;
> +		ha_region->covered_start_pfn = pg_start;
> +		ha_region->covered_end_pfn = pg_start;
> +		ha_region->end_pfn = rg_start + rg_size;
> +	}
> +
> +do_pg_range:
> +	/*
> +	 * Process the page range specified; bringing them
> +	 * online if possible.
> +	 */
> +	return handle_pg_range(pg_start, pfn_cnt);
> +}
> +
> +static void hot_add_req(struct work_struct *dummy)
> +{
> +	struct dm_hot_add_response resp;
> +	unsigned long pg_start, pfn_cnt;
> +	unsigned long rg_start, rg_sz;
> +	struct hv_dynmem_device *dm = &dm_device;
> +
>  	memset(&resp, 0, sizeof(struct dm_hot_add_response));
>  	resp.hdr.type = DM_MEM_HOT_ADD_RESPONSE;
>  	resp.hdr.size = sizeof(struct dm_hot_add_response);
>  	resp.hdr.trans_id = atomic_inc_return(&trans_id);
> 
> -	resp.page_count = 0;
> -	resp.result = 0;
> +	pg_start = dm->ha_wrk.ha_page_range.finfo.start_page;
> +	pfn_cnt = dm->ha_wrk.ha_page_range.finfo.page_cnt;
> 
> -	dm_device.state = DM_INITIALIZED;
> -	vmbus_sendpacket(dm_device.dev->channel, &resp,
> +	rg_start = dm->ha_wrk.ha_region_range.finfo.start_page;
> +	rg_sz = dm->ha_wrk.ha_region_range.finfo.page_cnt;
> +
> +	if ((rg_start == 0) && (!dm->host_specified_ha_region)) {
> +		unsigned long region_size;
> +		unsigned long region_start;
> +
> +		/*
> +		 * The host has not specified the hot-add region.
> +		 * Based on the hot-add page range being specified,
> +		 * compute a hot-add region that can cover the pages
> +		 * that need to be hot-added while ensuring the alignment
> +		 * and size requirements of Linux as it relates to hot-add.
> +		 */
> +		region_start = pg_start;
> +		region_size = (pfn_cnt / HA_CHUNK) * HA_CHUNK;
> +		if (pfn_cnt % HA_CHUNK)
> +			region_size += HA_CHUNK;
> +
> +		region_start = (pg_start / HA_CHUNK) * HA_CHUNK;
> +
> +		rg_start = region_start;
> +		rg_sz = region_size;
> +	}
> +
> +	resp.page_count = process_hot_add(pg_start, pfn_cnt,
> +					rg_start, rg_sz);
> +	if (resp.page_count > 0)
> +		resp.result = 1;
> +	else
> +		resp.result = 0;
> +
> +	if (!do_hot_add || (resp.page_count == 0))
> +		pr_info("Memory hot add failed\n");
> +
> +	dm->state = DM_INITIALIZED;
> +	vmbus_sendpacket(dm->dev->channel, &resp,
>  			sizeof(struct dm_hot_add_response),
>  			(unsigned long)NULL,
>  			VM_PKT_DATA_INBAND, 0);
> -
>  }
> 
>  static void process_info(struct hv_dynmem_device *dm, struct dm_info_msg
> *msg)
> @@ -867,6 +1192,7 @@ static void balloon_onchannelcallback(void *context)
>  	struct dm_balloon *bal_msg;
>  	struct dm_hot_add *ha_msg;
>  	union dm_mem_page_range *ha_pg_range;
> +	union dm_mem_page_range *ha_region;
> 
>  	memset(recv_buffer, 0, sizeof(recv_buffer));
>  	vmbus_recvpacket(dev->channel, recv_buffer,
> @@ -907,8 +1233,26 @@ static void balloon_onchannelcallback(void *context)
>  				pr_warn("Currently hot-adding\n");
>  			dm->state = DM_HOT_ADD;
>  			ha_msg = (struct dm_hot_add *)recv_buffer;
> -			ha_pg_range = &ha_msg->range;
> -			dm_device.ha_wrk.ha_page_range = *ha_pg_range;
> +			if (ha_msg->hdr.size == sizeof(struct dm_hot_add)) {
> +				/*
> +				 * This is a normal hot-add request specifying
> +				 * hot-add memory.
> +				 */
> +				ha_pg_range = &ha_msg->range;
> +				dm->ha_wrk.ha_page_range = *ha_pg_range;
> +				dm->ha_wrk.ha_region_range.page_range = 0;
> +			} else {
> +				/*
> +				 * Host is specifying that we first hot-add
> +				 * a region and then partially populate this
> +				 * region.
> +				 */
> +				dm->host_specified_ha_region = true;
> +				ha_pg_range = &ha_msg->range;
> +				ha_region = &ha_pg_range[1];
> +				dm->ha_wrk.ha_page_range = *ha_pg_range;
> +				dm->ha_wrk.ha_region_range = *ha_region;
> +			}
>  			schedule_work(&dm_device.ha_wrk.wrk);
>  			break;
> 
> @@ -952,8 +1296,10 @@ static int balloon_probe(struct hv_device *dev,
>  	dm_device.next_version = DYNMEM_PROTOCOL_VERSION_WIN7;
>  	init_completion(&dm_device.host_event);
>  	init_completion(&dm_device.config_event);
> +	INIT_LIST_HEAD(&dm_device.ha_region_list);
>  	INIT_WORK(&dm_device.balloon_wrk.wrk, balloon_up);
>  	INIT_WORK(&dm_device.ha_wrk.wrk, hot_add_req);
> +	dm_device.host_specified_ha_region = false;
> 
>  	dm_device.thread =
>  		 kthread_run(dm_thread_func, &dm_device, "hv_balloon");
> @@ -962,6 +1308,8 @@ static int balloon_probe(struct hv_device *dev,
>  		goto probe_error1;
>  	}
> 
> +	set_online_page_callback(&hv_online_page);
> +
>  	hv_set_drvdata(dev, &dm_device);
>  	/*
>  	 * Initiate the hand shake with the host and negotiate
> @@ -1006,12 +1354,6 @@ static int balloon_probe(struct hv_device *dev,
>  	cap_msg.hdr.trans_id = atomic_inc_return(&trans_id);
> 
>  	cap_msg.caps.cap_bits.balloon = 1;
> -	/*
> -	 * While we currently don't support hot-add,
> -	 * we still advertise this capability since the
> -	 * host requires that guests partcipating in the
> -	 * dynamic memory protocol support hot add.
> -	 */
>  	cap_msg.caps.cap_bits.hot_add = 1;
> 
>  	/*
> @@ -1061,15 +1403,24 @@ probe_error0:
>  static int balloon_remove(struct hv_device *dev)
>  {
>  	struct hv_dynmem_device *dm = hv_get_drvdata(dev);
> +	struct list_head *cur, *tmp;
> +	struct hv_hotadd_state *has;
> 
>  	if (dm->num_pages_ballooned != 0)
>  		pr_warn("Ballooned pages: %d\n", dm->num_pages_ballooned);
> 
>  	cancel_work_sync(&dm->balloon_wrk.wrk);
>  	cancel_work_sync(&dm->ha_wrk.wrk);
> +
>  	vmbus_close(dev->channel);
>  	kthread_stop(dm->thread);
>  	kfree(send_buffer);
> +	restore_online_page_callback(&hv_online_page);
> +	list_for_each_safe(cur, tmp, &dm->ha_region_list) {
> +		has = list_entry(cur, struct hv_hotadd_state, list);
> +		list_del(&has->list);
> +		kfree(has);
> +	}
> 
>  	return 0;
>  }
> --
> 1.7.4.1
> 
> 


