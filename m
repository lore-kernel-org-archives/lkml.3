Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaG1TAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:00:19 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53081 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaG1TAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:00:16 -0400
Date: Mon, 28 Jul 2014 21:00:09 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: char: sclp_async.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
Message-ID: <20140728190009.GB3769@osiris>
References: <1406385047-2942-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406385047-2942-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072819-8372-0000-0000-000000AC4F0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 04:30:47PM +0200, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/s390/char/sclp_async.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/char/sclp_async.c b/drivers/s390/char/sclp_async.c
> index 5f9f929..585de0a 100644
> --- a/drivers/s390/char/sclp_async.c
> +++ b/drivers/s390/char/sclp_async.c
> @@ -132,12 +132,12 @@ static int sclp_async_send_wait(char *message)
>  	request->command = SCLP_CMDW_WRITE_EVENT_DATA;
>  	request->sccb = sccb;
>  	request->status = SCLP_REQ_FILLED;
> -	strncpy(sccb->evbuf.data, message, sizeof(sccb->evbuf.data));
> +	strlcpy(sccb->evbuf.data, message, sizeof(sccb->evbuf.data));

Do your patches actually fix any bugs? E.g. this line fills a hardware data
structure, which must not necessarily be null terminated. Actually you even
could have introduced a bug here.
So, please state which of your patches actually do fix bugs.

