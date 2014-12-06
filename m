Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaLFCk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:40:56 -0500
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:5374
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751016AbaLFCkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:40:55 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Long Li <longli@microsoft.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Long Li <longli@microsoft.com>
Subject: RE: drivers:scsi:storvsc: Fix a bug in handling ring buffer failures
 that may result in I/O freeze
Thread-Topic: drivers:scsi:storvsc: Fix a bug in handling ring buffer failures
 that may result in I/O freeze
Thread-Index: AQHQEPxc2A4XviKud0i1evfuqn+/PJyB2UdQ
Date: Sat, 6 Dec 2014 02:40:51 +0000
Message-ID: <BY2PR0301MB0711D4CE74D3EFA7FB8D346BA0660@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417837098-23815-1-git-send-email-longli@microsoft.com>
In-Reply-To: <1417837098-23815-1-git-send-email-longli@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 0417A3FFD2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(13464003)(51704005)(377454003)(199003)(20776003)(101416001)(76576001)(1511001)(64706001)(66066001)(2561002)(31966008)(68736005)(87936001)(2656002)(105586002)(4396001)(106116001)(106356001)(74316001)(97736003)(99286002)(62966003)(77156002)(21056001)(107046002)(54206007)(92566001)(50986999)(54356999)(19580405001)(86612001)(86362001)(19580395003)(46102003)(2421001)(33656002)(575784001)(99396003)(76176999)(122556002)(54606007)(120916001)(40100003)(102836002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Long Li [mailto:longli@microsoft.com]
> Sent: Friday, December 5, 2014 7:38 PM
> To: linux-scsi@vger.kernel.org
> Cc: KY Srinivasan; Haiyang Zhang; JBottomley@parallels.com;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Long Li
> Subject: drivers:scsi:storvsc: Fix a bug in handling ring buffer failures that may
> result in I/O freeze
> 
> When ring buffer returns an error indicating retry, storvsc may not return a
> proper error code to SCSI when bounce buffer is not used. This has
> introduced I/O freeze on RAID running atop storvsc devices. This patch fixes
> it by always returning a proper error code.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
cc: stable@vger.kernel.org

> ---
>  drivers/scsi/storvsc_drv.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> e3ba251..4cff0dd 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1688,13 +1688,12 @@ static int storvsc_queuecommand(struct
> Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	if (ret == -EAGAIN) {
>  		/* no more space */
> 
> -		if (cmd_request->bounce_sgl_count) {
> +		if (cmd_request->bounce_sgl_count)
>  			destroy_bounce_buffer(cmd_request->bounce_sgl,
>  					cmd_request->bounce_sgl_count);
> 
> -			ret = SCSI_MLQUEUE_DEVICE_BUSY;
> -			goto queue_error;
> -		}
> +		ret = SCSI_MLQUEUE_DEVICE_BUSY;
> +		goto queue_error;
>  	}
> 
>  	return 0;
> --
> 2.1.0

