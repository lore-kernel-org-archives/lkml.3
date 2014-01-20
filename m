Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaATWNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:13:37 -0500
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:35039
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753183AbaATWNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:13:34 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPEVjnKHWBxAK/ME2641uqAhZ1vZqHLleAgAcH9OA=
Date: Mon, 20 Jan 2014 22:13:30 +0000
Message-ID: <b29b3b91ff654abab607fe7b689bbfeb@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
 <20140116104841.GA21768@aepfle.de>
In-Reply-To: <20140116104841.GA21768@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.159.229]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377454003)(13464003)(51704005)(24454002)(189002)(199002)(74706001)(83072002)(76482001)(81816001)(90146001)(87266001)(47446002)(2656002)(54316002)(74316001)(31966008)(80022001)(93136001)(47976001)(81542001)(74502001)(87936001)(66066001)(85852003)(81686001)(74876001)(54356001)(46102001)(51856001)(74366001)(79102001)(53806001)(65816001)(56816005)(63696002)(85306002)(59766001)(76796001)(76786001)(76576001)(33646001)(77982001)(86362001)(56776001)(575784001)(92566001)(80976001)(4396001)(74662001)(50986001)(69226001)(93516002)(47736001)(19580405001)(83322001)(81342001)(49866001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.159.229;FPR:;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0KMDg93006523

Olaf,

I am cleaning up the code based on your feedback. By the time I am done with my cleanup, I doubt if
this patch would apply. Do you mind if I were to include your changes here as part of my cleanup?

Thank you,

K. Y

> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Thursday, January 16, 2014 2:49 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
> 
> On Tue, Jan 14, K. Y. Srinivasan wrote:
> 
> > Implement the file copy service for Linux guests on Hyper-V. This permits the
> > host to copy a file (over VMBUS) into the guest. This facility is part of
> > "guest integration services" supported on the Windows platform.
> > Here is a link that provides additional details on this functionality:
> 
> The change below fixes some warnings in the daemon code.
> Compile tested only.
> I also think the newlines in some of the syslog calls should be removed.
> 
> Olaf
> 
> 
> hv_fcopy_daemon.c: In function 'hv_start_fcopy':
> hv_fcopy_daemon.c:44:3: warning: format '%s' expects argument of type 'char
> *', but argument 3 has type '__u16 *' [-Wformat=]
>    smsg->file_name);
>    ^
> hv_fcopy_daemon.c:44:3: warning: format '%s' expects argument of type 'char
> *', but argument 5 has type '__u16 *' [-Wformat=]
> hv_fcopy_daemon.c:57:6: warning: format '%s' expects argument of type 'char
> *', but argument 3 has type '__u16 *' [-Wformat=]
>       errno, strerror(errno));
>       ^
> hv_fcopy_daemon.c:61:4: warning: format '%s' expects argument of type 'char
> *', but argument 3 has type '__u16 *' [-Wformat=]
>     syslog(LOG_ERR, "Invalid path: %s\n", smsg->path_name);
>     ^
> hv_fcopy_daemon.c: In function 'main':
> hv_fcopy_daemon.c:117:8: warning: ignoring return value of 'daemon', declared
> with attribute warn_unused_result [-Wunused-result]
>   daemon(1, 0);
>         ^
> hv_fcopy_daemon.c:132:7: warning: ignoring return value of 'write', declared
> with attribute warn_unused_result [-Wunused-result]
>   write(fcopy_fd, &version, sizeof(int));
>        ^
> hv_fcopy_daemon.c:171:9: warning: ignoring return value of 'pwrite', declared
> with attribute warn_unused_result [-Wunused-result]
>    pwrite(fcopy_fd, &error, sizeof(int), 0);
>          ^
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
> index c0e5c90..d1fadb7 100644
> --- a/tools/hv/hv_fcopy_daemon.c
> +++ b/tools/hv/hv_fcopy_daemon.c
> @@ -35,14 +35,14 @@
>  #include <dirent.h>
> 
>  static int target_fd;
> -char target_fname[W_MAX_PATH];
> +static char target_fname[W_MAX_PATH];
> 
>  static int hv_start_fcopy(struct hv_start_fcopy *smsg)
>  {
>  	int error = HV_E_FAIL;
> 
> -	sprintf(target_fname, "%s%s%s", smsg->path_name, "/",
> -		smsg->file_name);
> +	snprintf(target_fname, sizeof(target_fname), "%s/%s",
> +			(char *)smsg->path_name, (char*)smsg->file_name);
> 
>  	syslog(LOG_INFO, "Target file name: %s\n", target_fname);
>  	/*
> @@ -54,12 +54,12 @@ static int hv_start_fcopy(struct hv_start_fcopy *smsg)
>  			if (mkdir((char *)smsg->path_name, 0755)) {
>  				syslog(LOG_ERR,
>  					"Failed to create '%s'; error: %d %s\n",
> -					smsg->path_name,
> +					(char *)smsg->path_name,
>  					errno, strerror(errno));
>  				goto done;
>  			}
>  		} else {
> -			syslog(LOG_ERR, "Invalid path: %s\n", smsg-
> >path_name);
> +			syslog(LOG_ERR, "Invalid path: %s", (char *)smsg-
> >path_name);
>  			goto done;
>  		}
>  	}
> @@ -115,7 +115,8 @@ int main(void)
>  	char *buffer[4096 * 2];
>  	struct hv_fcopy_hdr *in_msg;
> 
> -	daemon(1, 0);
> +	if (daemon(1, 0))
> +		return 1;
>  	openlog("HV_FCOPY", 0, LOG_USER);
>  	syslog(LOG_INFO, "HV_FCOPY starting; pid is:%d", getpid());
> 
> @@ -130,7 +131,10 @@ int main(void)
>  	/*
>  	 * Register with the kernel.
>  	 */
> -	write(fcopy_fd, &version, sizeof(int));
> +	if (write(fcopy_fd, &version, sizeof(int)) != sizeof(int)) {
> +		syslog(LOG_ERR, "write failed: %s",strerror(errno));
> +		exit(EXIT_FAILURE);
> +	}
> 
>  	while (1) {
>  		/*
> @@ -169,6 +173,9 @@ int main(void)
> 
>  		}
> 
> -		pwrite(fcopy_fd, &error, sizeof(int), 0);
> +		if (pwrite(fcopy_fd, &error, sizeof(int), 0) != sizeof(int)) {
> +			syslog(LOG_ERR, "pwrite failed: %s",strerror(errno));
> +			exit(EXIT_FAILURE);
> +		}
>  	}
>  }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
