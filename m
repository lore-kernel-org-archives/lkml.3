Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbaLJSzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:55:17 -0500
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:24128
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932501AbaLJSzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:55:15 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH 4/5] Tools: hv: address compiler warnings for
 hv_fcopy_daemon.c
Thread-Topic: [PATCH 4/5] Tools: hv: address compiler warnings for
 hv_fcopy_daemon.c
Thread-Index: AQHQE8s0MgLIHRxbeE6RUFJzMGfpO5yJLgXA
Date: Wed, 10 Dec 2014 18:55:13 +0000
Message-ID: <BY2PR0301MB071185A92053C71F55ADDDF4A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <1418140103-11854-5-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-5-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0773;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0773;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(189002)(377454003)(199003)(51704005)(99396003)(120916001)(97736003)(76576001)(122556002)(107046002)(99286002)(102836002)(110136001)(68736005)(105586002)(40100003)(20776003)(106116001)(106356001)(46102003)(64706001)(86612001)(31966008)(19580405001)(4396001)(87936001)(76176999)(77156002)(86362001)(50986999)(21056001)(92566001)(101416001)(2656002)(54356999)(33656002)(62966003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0773;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBAItPg1008218



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, December 9, 2014 7:48 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH 4/5] Tools: hv: address compiler warnings for
> hv_fcopy_daemon.c
> 
> This patch addresses two types of compiler warnings:
> ... warning: unused variable â€˜fdâ€™ [-Wunused-variable] and ... warning: format
> â€˜%sâ€™ expects argument of type â€˜char *â€™, but argument 5 has type â€˜__u16 *â€™ [-
> Wformat=]
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_fcopy_daemon.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
> index f437d73..1a23872 100644
> --- a/tools/hv/hv_fcopy_daemon.c
> +++ b/tools/hv/hv_fcopy_daemon.c
> @@ -51,7 +51,7 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
> 
>  	p = (char *)smsg->path_name;
>  	snprintf(target_fname, sizeof(target_fname), "%s/%s",
> -		(char *)smsg->path_name, smsg->file_name);
> +		 (char *)smsg->path_name, (char *)smsg->file_name);
> 
>  	syslog(LOG_INFO, "Target file name: %s", target_fname);
>  	/*
> @@ -137,7 +137,7 @@ void print_usage(char *argv[])
> 
>  int main(int argc, char *argv[])
>  {
> -	int fd, fcopy_fd, len;
> +	int fcopy_fd, len;
>  	int error;
>  	int daemonize = 1, long_index = 0, opt;
>  	int version = FCOPY_CURRENT_VERSION;
> --
> 1.9.3

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
