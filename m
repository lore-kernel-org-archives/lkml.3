Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034Ab3JOXcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:32:16 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:28896
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934006Ab3JOXcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:32:14 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Felipe Pena <felipensp@gmail.com>, Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] drivers: hv: Fix wrong check for synic_event_page
Thread-Topic: [PATCH 1/1] drivers: hv: Fix wrong check for synic_event_page
Thread-Index: AQHOyf1id4FxnOwTzky48wHDT1SMbZn2Z6Ww
Date: Tue, 15 Oct 2013 23:32:11 +0000
Message-ID: <3290cfb057c940ab8853de586a3730c2@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1381879352-3686-1-git-send-email-felipensp@gmail.com>
In-Reply-To: <1381879352-3686-1-git-send-email-felipensp@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::2]
x-forefront-prvs: 00003DBFE7
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(13464003)(377454003)(51704005)(81816001)(47446002)(54316002)(31966008)(56776001)(1511001)(74502001)(77096001)(56816003)(63696002)(80976001)(74662001)(79102001)(76482001)(81686001)(59766001)(77982001)(65816001)(80022001)(76576001)(76786001)(74876001)(54356001)(74706001)(76796001)(4396001)(47736001)(49866001)(46102001)(51856001)(47976001)(50986001)(85306002)(83072001)(19580405001)(19580395003)(83322001)(53806001)(33646001)(74316001)(69226001)(74366001)(81542001)(81342001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ed43::2;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Felipe Pena [mailto:felipensp@gmail.com]
> Sent: Tuesday, October 15, 2013 4:23 PM
> To: KY Srinivasan; Haiyang Zhang
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Felipe Pena
> Subject: [PATCH 1/1] drivers: hv: Fix wrong check for synic_event_page
> 
> The check for calling free_page() on hv_context.synic_event_page[cpu] is the
> same for hv_context.synic_message_page[cpu], like a copy-paste error.
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>

Thanks Felipe.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

K. Y


> ---
>  drivers/hv/hv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index 88f4096..f0c5e07 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -304,7 +304,7 @@ err:
>  void hv_synic_free_cpu(int cpu)
>  {
>  	kfree(hv_context.event_dpc[cpu]);
> -	if (hv_context.synic_message_page[cpu])
> +	if (hv_context.synic_event_page[cpu])
>  		free_page((unsigned long)hv_context.synic_event_page[cpu]);
>  	if (hv_context.synic_message_page[cpu])
>  		free_page((unsigned
> long)hv_context.synic_message_page[cpu]);
> --
> 1.7.10.4

