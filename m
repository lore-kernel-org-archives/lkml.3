Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3BZMST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:18:19 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:50148 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab3BZMSS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:18:18 -0500
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: Tim Gardner <tim.gardner@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        Support <support@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "DL-MPT Fusion Linux" <DL-MPTFusionLinux@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Tue, 26 Feb 2013 17:48:13 +0530
Subject: RE: [PATCH linux/linux-next] mpt2sas:
 _scsih_sas_broadcast_primitive_event: Quiet unused variable warning
Thread-Topic: [PATCH linux/linux-next] mpt2sas:
 _scsih_sas_broadcast_primitive_event: Quiet unused variable warning
Thread-Index: Ac4Pmu9Yn03e0AYSQ9uugDCqrx3F5wEf2M9w
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E77C8E99@inbmail02.lsi.com>
References: <1361386107-49136-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1361386107-49136-1-git-send-email-tim.gardner@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Today I have sent the below titled patch to upstream which fix the "Unused variable 'event_data' warning".
 The Patch title is 
	"[PATCH][SCSI] mpt2sas: fix for unused variable 'event_data' warning"

This patch will help you in fixing the "Unused variable 'event_data' warning".

Thanks,
Sreekanth

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Tim Gardner
> Sent: Thursday, February 21, 2013 12:18 AM
> To: linux-kernel@vger.kernel.org
> Cc: Tim Gardner; Nandigama, Nagalakshmi; Reddy, Sreekanth; Support;
> James E.J. Bottomley; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org
> Subject: [PATCH linux/linux-next] mpt2sas:
> _scsih_sas_broadcast_primitive_event: Quiet unused variable warning
> 
> If CONFIG_SCSI_MPT2SAS_LOGGING is undefined, then these warnings are
> emitted:
> 
> drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function
> '_scsih_sas_broadcast_primitive_event':
> drivers/scsi/mpt2sas/mpt2sas_scsih.c:5810:40: warning: unused variable
> 'event_data' [-Wunused-variable]
> 
> Add __maybe_unused to the definition of event_data.
> 
> Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: support@lsi.com
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: DL-MPTFusionLinux@lsi.com
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c6bdc92..416f907 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -5807,7 +5807,8 @@ _scsih_sas_broadcast_primitive_event(struct
> MPT2SAS_ADAPTER *ioc,
>  	u32 termination_count;
>  	u32 query_count;
>  	Mpi2SCSITaskManagementReply_t *mpi_reply;
> -	Mpi2EventDataSasBroadcastPrimitive_t *event_data = fw_event-
> >event_data;
> +	Mpi2EventDataSasBroadcastPrimitive_t *event_data
> __maybe_unused =
> +		fw_event->event_data;
>  	u16 ioc_status;
>  	unsigned long flags;
>  	int r;
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
