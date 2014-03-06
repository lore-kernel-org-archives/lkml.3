Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaCFNK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:10:27 -0500
Received: from mx2.compro.net ([12.186.155.30]:57298 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750714AbaCFNK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:10:26 -0500
X-Greylist: delayed 788 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 08:10:26 EST
X-BYPSHEADER: 2739599
X-SMScore: -1000
Message-ID: <531870AD.1080403@compro.net>
Date: Thu, 06 Mar 2014 07:57:17 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>, lidza.louina@gmail.com,
        gregkh@linuxfoundation.org
CC: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgap: remove useless cast on kzalloc()
References: <920618656.203780.1394086679844.JavaMail.root@mx2.compro.net>
In-Reply-To: <920618656.203780.1394086679844.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 01:17 AM, Daeseok Youn wrote:
>
> coccinelle warning:
> drivers/staging/dgap/dgap.c:782:3-7: WARNING:
>   casting value returned by k[cmz]alloc to (char *) is useless.
> drivers/staging/dgap/dgap.c:776:2-16: WARNING:
>   casting value returned by k[cmz]alloc to (struct board_t *) is useless.
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>   drivers/staging/dgap/dgap.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
> index cbce457..1adcd13 100644
> --- a/drivers/staging/dgap/dgap.c
> +++ b/drivers/staging/dgap/dgap.c
> @@ -773,13 +773,13 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
>
>   	/* get the board structure and prep it */
>   	brd = dgap_Board[dgap_NumBoards] =
> -	(struct board_t *) kzalloc(sizeof(struct board_t), GFP_KERNEL);
> +		kzalloc(sizeof(struct board_t), GFP_KERNEL);
>   	if (!brd)
>   		return -ENOMEM;
>
>   	/* make a temporary message buffer for the boot messages */
>   	brd->msgbuf = brd->msgbuf_head =
> -		(char *) kzalloc(sizeof(char) * 8192, GFP_KERNEL);
> +		kzalloc(sizeof(char) * 8192, GFP_KERNEL);
>   	if (!brd->msgbuf) {
>   		kfree(brd);
>   		return -ENOMEM;
>

I'm pretty sure this has already been fixed up in current staging-next.

Thanks
Mark
