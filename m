Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaG1QC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:02:26 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:43555 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaG1QCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:02:24 -0400
In-Reply-To: <1406010572-13217-1-git-send-email-xerofoify@gmail.com>
References: <1406010572-13217-1-git-send-email-xerofoify@gmail.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: BOEBLINGEN LINUX390 <LINUX390@de.ibm.com>, heicars2@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        mschwid2@linux.vnet.ibm.com,
        Stefan Haberland1 <stefan.haberland@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] s390: Fix me in dasd_eer.c
X-KeepSent: 27B55084:24F3FB57-C1257D23:0054AF74;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3FP5 Septem 15, 2011
From: Stefan Weinhuber <WEIN@de.ibm.com>
Message-ID: <OF27B55084.24F3FB57-ONC1257D23.0054AF74-C1257D23.0058198E@de.ibm.com>
Date: Mon, 28 Jul 2014 18:02:13 +0200
X-MIMETrack: Serialize by Router on D06ML030/06/M/IBM(Release 8.5.3FP5IF1HF4|May 06, 2014) at
 28/07/2014 18:02:13,
	Serialize complete at 28/07/2014 18:02:13
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072816-4966-0000-0000-000000DC2E82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicholas Krause <xerofoify@gmail.com> wrote on 2014-07-22 08:29:32:

[..] 
> Subject:
> 
> [PATCH] s390: Fix me in dasd_eer.c
> 
> This patch changes return type to EMEDUIMTYPE in function, 
dasd_eer_enable
> for when checking if the medium has no errors according to this 
function.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/s390/block/dasd_eer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/block/dasd_eer.c 
b/drivers/s390/block/dasd_eer.c
> index 21ef63c..08ee040 100644
> --- a/drivers/s390/block/dasd_eer.c
> +++ b/drivers/s390/block/dasd_eer.c
> @@ -462,7 +462,7 @@ int dasd_eer_enable(struct dasd_device *device)
>        return 0;
> 
>     if (!device->discipline || strcmp(device->discipline->name, "ECKD"))
> -      return -EPERM;   /* FIXME: -EMEDIUMTYPE ? */
> +      return -EMEDIUMTYPE;   /* FIXME: -EMEDIUMTYPE ? */
> 
>     cqr = dasd_kmalloc_request(DASD_ECKD_MAGIC, 1 /* SNSS */,
>                 SNSS_DATA_SIZE, device);
> -- 
> 1.9.1
>

Hm, after some consideration, I have to disagree with your suggestion.
If you try to enable EER on an FBA device, you will get the following
result with current code:

$ echo 1 > eer_enabled
-bash: echo: write error: Operation not permitted

and with your code the following:

$ echo 1 > eer_enabled
-bash: echo: write error: Wrong medium type

When I wrote this code, I was not sure which one is better. But today I 
say
that the 'Operation not permitted' is more to the point. An FBA device
has no (changable) medium, so what could be wrong about its type?
Could be confusing.

>From your patch description I do not really get why you want to change the
return code. Why do you think that EMEDIUMTYPE is better than EPERM?

Mit freundlichen Grüßen / Kind regards
 
Stefan Weinhuber

