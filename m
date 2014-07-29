Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaG2NLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:11:11 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49553 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaG2NLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:11:09 -0400
Message-ID: <1406639463.13705.9.camel@BR9GV9YG.de.ibm.com>
Subject: Re: [PATCH] s390: net: ctcm_main.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2014 15:11:03 +0200
In-Reply-To: <1406385234-3123-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406385234-3123-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072913-0342-0000-0000-00000096664C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 16:33 +0200, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/s390/net/ctcm_main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
> index 03b6ad0..670fa7d 100644
> --- a/drivers/s390/net/ctcm_main.c
> +++ b/drivers/s390/net/ctcm_main.c
> @@ -204,8 +204,8 @@ static void channel_remove(struct channel *ch)
> 
>  	if (ch == NULL)
>  		return;
> -	else
> -		strncpy(chid, ch->id, CTCM_ID_SIZE);
> +
> +	strlcpy(chid, ch->id, CTCM_ID_SIZE);
> 
>  	channel_free(ch);
>  	while (*c) {

It is guaranteed that the string ch->id always fits into CTCM_ID_SIZE.
What's in this case the benefit of replacing strncpy() by strlcpy()
here?

I agree to remove the useless "else".

 

