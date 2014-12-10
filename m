Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbaLJSv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:51:56 -0500
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:9745
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932501AbaLJSvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:51:55 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH 3/5] Tools: hv: address compiler warnings for
 hv_kvp_daemon.c
Thread-Topic: [PATCH 3/5] Tools: hv: address compiler warnings for
 hv_kvp_daemon.c
Thread-Index: AQHQE8eX+ZMZRRqUKk2w6iBWjIlqnJyJLPWg
Date: Wed, 10 Dec 2014 18:51:53 +0000
Message-ID: <BY2PR0301MB0711EF97E6C5294EFAD75E72A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <1418140103-11854-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1418140103-11854-4-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(13464003)(377454003)(189002)(199003)(64706001)(110136001)(20776003)(107046002)(99286002)(97736003)(105586002)(21056001)(120916001)(99396003)(54206007)(106356001)(122556002)(40100003)(92566001)(76176999)(54356999)(50986999)(76576001)(54606007)(101416001)(87936001)(2656002)(106116001)(4396001)(77156002)(62966003)(33656002)(46102003)(86362001)(102836002)(19580405001)(68736005)(86612001)(31966008)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0775;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBAIq4JC008173



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, December 9, 2014 7:48 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH 3/5] Tools: hv: address compiler warnings for
> hv_kvp_daemon.c
> 
> This patch addresses two types of compiler warnings:
> ... warning: comparison between signed and unsigned integer expressions [-
> Wsign-compare] and ... warning: pointer targets in passing argument N of
> â€˜kvp_...â€™ differ in signedness [-Wpointer-sign]
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Thanks Vitaly.

K. Y

> ---
>  tools/hv/hv_kvp_daemon.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c index
> 5a274ca..48a95f9 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -308,7 +308,7 @@ static int kvp_file_init(void)
>  	return 0;
>  }
> 
> -static int kvp_key_delete(int pool, const char *key, int key_size)
> +static int kvp_key_delete(int pool, const __u8 *key, int key_size)
>  {
>  	int i;
>  	int j, k;
> @@ -351,8 +351,8 @@ static int kvp_key_delete(int pool, const char *key,
> int key_size)
>  	return 1;
>  }
> 
> -static int kvp_key_add_or_modify(int pool, const char *key, int key_size,
> const char *value,
> -			int value_size)
> +static int kvp_key_add_or_modify(int pool, const __u8 *key, int key_size,
> +				 const __u8 *value, int value_size)
>  {
>  	int i;
>  	int num_records;
> @@ -405,7 +405,7 @@ static int kvp_key_add_or_modify(int pool, const char
> *key, int key_size, const
>  	return 0;
>  }
> 
> -static int kvp_get_value(int pool, const char *key, int key_size, char *value,
> +static int kvp_get_value(int pool, const __u8 *key, int key_size, __u8
> +*value,
>  			int value_size)
>  {
>  	int i;
> @@ -437,8 +437,8 @@ static int kvp_get_value(int pool, const char *key, int
> key_size, char *value,
>  	return 1;
>  }
> 
> -static int kvp_pool_enumerate(int pool, int index, char *key, int key_size,
> -				char *value, int value_size)
> +static int kvp_pool_enumerate(int pool, int index, __u8 *key, int key_size,
> +				__u8 *value, int value_size)
>  {
>  	struct kvp_record *record;
> 
> @@ -659,7 +659,7 @@ static char *kvp_if_name_to_mac(char *if_name)
>  	char    *p, *x;
>  	char    buf[256];
>  	char addr_file[256];
> -	int i;
> +	unsigned int i;
>  	char *mac_addr = NULL;
> 
>  	snprintf(addr_file, sizeof(addr_file), "%s%s%s", "/sys/class/net/",
> @@ -698,7 +698,7 @@ static char *kvp_mac_to_if_name(char *mac)
>  	char    buf[256];
>  	char *kvp_net_dir = "/sys/class/net/";
>  	char dev_id[256];
> -	int i;
> +	unsigned int i;
> 
>  	dir = opendir(kvp_net_dir);
>  	if (dir == NULL)
> @@ -748,7 +748,7 @@ static char *kvp_mac_to_if_name(char *mac)
> 
> 
>  static void kvp_process_ipconfig_file(char *cmd,
> -					char *config_buf, int len,
> +					char *config_buf, unsigned int len,
>  					int element_size, int offset)
>  {
>  	char buf[256];
> @@ -766,7 +766,7 @@ static void kvp_process_ipconfig_file(char *cmd,
>  	if (offset == 0)
>  		memset(config_buf, 0, len);
>  	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
> -		if ((len - strlen(config_buf)) < (element_size + 1))
> +		if (len < strlen(config_buf) + element_size + 1)
>  			break;
> 
>  		x = strchr(p, '\n');
> @@ -914,7 +914,7 @@ static int kvp_process_ip_address(void *addrp,
> 
>  static int
>  kvp_get_ip_info(int family, char *if_name, int op,
> -		 void  *out_buffer, int length)
> +		 void  *out_buffer, unsigned int length)
>  {
>  	struct ifaddrs *ifap;
>  	struct ifaddrs *curp;
> @@ -1017,8 +1017,7 @@ kvp_get_ip_info(int family, char *if_name, int op,
>  					weight += hweight32(&w[i]);
> 
>  				sprintf(cidr_mask, "/%d", weight);
> -				if ((length - sn_offset) <
> -					(strlen(cidr_mask) + 1))
> +				if (length < sn_offset + strlen(cidr_mask) + 1)
>  					goto gather_ipaddr;
> 
>  				if (sn_offset == 0)
> --
> 1.9.3

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
