Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3FRM7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:59:44 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:47305
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752400Ab3FRM7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:59:42 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hz97hz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drivers: hv: switch to use mb() instead of smp_mb()
Thread-Topic: [PATCH] drivers: hv: switch to use mb() instead of smp_mb()
Thread-Index: AQHOa+Lt7loludD4eE+9cnkVwl0DDZk7bsqQ
Date: Tue, 18 Jun 2013 12:58:08 +0000
Message-ID: <572dfd2a52484936b598e50f29e99beb@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1371531863-12491-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1371531863-12491-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(377454002)(189002)(13464003)(51704005)(47736001)(47976001)(74876001)(54316002)(54356001)(74502001)(50466002)(4396001)(76482001)(80022001)(65816001)(81342001)(74366001)(76796001)(77982001)(63696002)(23726002)(47446002)(46406003)(74662001)(76786001)(46102001)(53806001)(56776001)(56816003)(74316001)(50986001)(6806003)(66066001)(59766001)(31966008)(33646001)(44976003)(16676001)(76576001)(49866001)(47776003)(1511001)(74706001)(77096001)(79102001)(51856001)(20776003)(81542001)(69226001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB032;H:TK5EX14MLTC102.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0881A7A935
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Tuesday, June 18, 2013 1:04 AM
> To: KY Srinivasan; Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Cc: Jason Wang; stable@vger.kernel.org
> Subject: [PATCH] drivers: hv: switch to use mb() instead of smp_mb()
> 
> Even if guest were compiled without SMP support, it could not assume that host
> wasn't. So switch to use mb() instead of smp_mb() to force memory barriers for
> UP guest.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  drivers/hv/ring_buffer.c |   10 +++++-----
>  drivers/hv/vmbus_drv.c   |    2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index d6fbb57..791f45d 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -32,7 +32,7 @@
>  void hv_begin_read(struct hv_ring_buffer_info *rbi)
>  {
>  	rbi->ring_buffer->interrupt_mask = 1;
> -	smp_mb();
> +	mb();
>  }
> 
>  u32 hv_end_read(struct hv_ring_buffer_info *rbi)
> @@ -41,7 +41,7 @@ u32 hv_end_read(struct hv_ring_buffer_info *rbi)
>  	u32 write;
> 
>  	rbi->ring_buffer->interrupt_mask = 0;
> -	smp_mb();
> +	mb();
> 
>  	/*
>  	 * Now check to see if the ring buffer is still empty.
> @@ -71,7 +71,7 @@ u32 hv_end_read(struct hv_ring_buffer_info *rbi)
> 
>  static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
>  {
> -	smp_mb();
> +	mb();
>  	if (rbi->ring_buffer->interrupt_mask)
>  		return false;
> 
> @@ -442,7 +442,7 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info
> *outring_info,
>  					     sizeof(u64));
> 
>  	/* Issue a full memory barrier before updating the write index */
> -	smp_mb();
> +	mb();
> 
>  	/* Now, update the write location */
>  	hv_set_next_write_location(outring_info, next_write_location);
> @@ -549,7 +549,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info
> *inring_info, void *buffer,
>  	/* Make sure all reads are done before we update the read index since
> */
>  	/* the writer may start writing to the read area once the read index */
>  	/*is updated */
> -	smp_mb();
> +	mb();
> 
>  	/* Update the read index */
>  	hv_set_next_read_location(inring_info, next_read_location);
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index bf421e0..4004e54 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -434,7 +434,7 @@ static void vmbus_on_msg_dpc(unsigned long data)
>  		 * will not deliver any more messages since there is
>  		 * no empty slot
>  		 */
> -		smp_mb();
> +		mb();
> 
>  		if (msg->header.message_flags.msg_pending) {
>  			/*
> --
> 1.7.1
> 
> 


