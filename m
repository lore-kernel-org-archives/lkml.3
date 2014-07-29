Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaG2NNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:13:54 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:50542 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaG2NNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:13:53 -0400
Message-ID: <1406639627.13705.11.camel@BR9GV9YG.de.ibm.com>
Subject: Re: [PATCH] s390: net: qeth_core_main.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2014 15:13:47 +0200
In-Reply-To: <1406385326-3289-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406385326-3289-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072913-0342-0000-0000-000000966951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 16:35 +0200, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/s390/net/qeth_core_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index f54bec5..ec9b4d7 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -5275,7 +5275,7 @@ static int qeth_add_dbf_entry(struct qeth_card *card, char *name)
>  	new_entry = kzalloc(sizeof(struct qeth_dbf_entry), GFP_KERNEL);
>  	if (!new_entry)
>  		goto err_dbg;
> -	strncpy(new_entry->dbf_name, name, DBF_NAME_LEN);
> +	strlcpy(new_entry->dbf_name, name, DBF_NAME_LEN);
>  	new_entry->dbf_info = card->debug;
>  	mutex_lock(&qeth_dbf_list_mutex);
>  	list_add(&new_entry->dbf_list, &qeth_dbf_list);

It is guaranteed that the string ch->id always fits into DBF_NAME_LEN.
What's in this case the benefit of replacing strncpy() by strlcpy()
here?

