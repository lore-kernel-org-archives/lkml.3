Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaG1OZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:25:33 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:41745 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaG1OZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:25:30 -0400
Message-ID: <53D65D53.8000602@linux.vnet.ibm.com>
Date: Mon, 28 Jul 2014 16:25:23 +0200
From: Steffen Maier <maier@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux390@de.ibm.com
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: scsi: zfcp_aux.c:  Cleaning up missing null-terminate
 in conjunction with strncpy
References: <1406385418-3393-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1406385418-3393-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072814-4966-0000-0000-000000DBE018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2014 04:36 PM, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/s390/scsi/zfcp_aux.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
> index 8004b07..a23ba76 100644
> --- a/drivers/s390/scsi/zfcp_aux.c
> +++ b/drivers/s390/scsi/zfcp_aux.c
> @@ -101,7 +101,7 @@ static void __init zfcp_init_device_setup(char *devstr)
>   	token = strsep(&str, ",");
>   	if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
>   		goto err_out;

Due to the check for strlen(token) >= ZFCP_BUS_ID_SIZE we should be safe 
even with strlcpy because we would reject any user string that does not 
fit into busid including the trailing zero character.

Since it works either way, we can change it though,

Acked-by: Steffen Maier <maier@linux.vnet.ibm.com>

> -	strncpy(busid, token, ZFCP_BUS_ID_SIZE);
> +	strlcpy(busid, token, ZFCP_BUS_ID_SIZE);
>
>   	token = strsep(&str, ",");
>   	if (!token || kstrtoull(token, 0, (unsigned long long *) &wwpn))
>

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

