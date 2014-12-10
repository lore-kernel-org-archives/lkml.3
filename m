Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaLJStK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:49:10 -0500
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:32480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932765AbaLJStI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:49:08 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH 2/5] Tools: hv: remove unused bytes_written from
 kvp_update_file()
Thread-Topic: [PATCH 2/5] Tools: hv: remove unused bytes_written from
 kvp_update_file()
Thread-Index: AQHQE8eXx0FSkbWoCEmkpgQHak0EKpyJK/zQ
Date: Wed, 10 Dec 2014 18:49:05 +0000
Message-ID: <BY2PR0301MB07117433E01C33419CE67B02A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <1418140103-11854-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-3-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(199003)(51704005)(377454003)(189002)(107046002)(122556002)(87936001)(120916001)(2656002)(64706001)(20776003)(40100003)(110136001)(54606007)(99286002)(99396003)(54356999)(50986999)(106116001)(105586002)(4396001)(76176999)(19580405001)(97736003)(106356001)(74316001)(46102003)(54206007)(102836002)(86612001)(19580395003)(92566001)(62966003)(68736005)(77156002)(31966008)(76576001)(101416001)(21056001)(86362001)(33656002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBAInJWm008143



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, December 9, 2014 7:48 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH 2/5] Tools: hv: remove unused bytes_written from
> kvp_update_file()
> 
> fwrite() does not actually return the number of bytes written and this value
> is being ignored anyway and ferror() is being called to check for an error. As
> we assign to this variable and never use it we get the following compile-time
> warning:
> hv_kvp_daemon.c:149:9: warning: variable â€˜bytes_writtenâ€™ set but not used
> [-Wunused-but-set-variable]
> 
> Remove bytes_written completely.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c index
> 6a6432a..5a274ca 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -147,7 +147,6 @@ static void kvp_release_lock(int pool)  static void
> kvp_update_file(int pool)  {
>  	FILE *filep;
> -	size_t bytes_written;
> 
>  	/*
>  	 * We are going to write our in-memory registry out to @@ -163,8
> +162,7 @@ static void kvp_update_file(int pool)
>  		exit(EXIT_FAILURE);
>  	}
> 
> -	bytes_written = fwrite(kvp_file_info[pool].records,
> -				sizeof(struct kvp_record),
> +	fwrite(kvp_file_info[pool].records, sizeof(struct kvp_record),
>  				kvp_file_info[pool].num_records, filep);
> 
>  	if (ferror(filep) || fclose(filep)) {
> --
> 1.9.3

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
