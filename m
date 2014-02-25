Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaBYJq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:46:56 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:51827 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaBYJqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:46:51 -0500
Message-ID: <530C666B.6080900@mev.co.uk>
Date: Tue, 25 Feb 2014 09:46:19 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Monam Agarwal <monamagarwal123@gmail.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: Fix line length exceeding 80 characters
References: <1393260582-10234-1-git-send-email-monamagarwal123@gmail.com>
In-Reply-To: <1393260582-10234-1-git-send-email-monamagarwal123@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-24 16:49, Monam Agarwal wrote:
> Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> ---
>   drivers/staging/comedi/comedi_fops.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> index ac1edd9..7da8566 100644
> --- a/drivers/staging/comedi/comedi_fops.c
> +++ b/drivers/staging/comedi/comedi_fops.c
> @@ -1481,7 +1481,8 @@ static int do_cmd_ioctl(struct comedi_device *dev,
>   	async->cmd.data = NULL;
>   	/* load channel/gain list */
>   	async->cmd.chanlist = memdup_user(user_chanlist,
> -					  async->cmd.chanlist_len * sizeof(int));
> +					  async->cmd.chanlist_len
> +					  * sizeof(int));

The `*` operator should go at the end of the line according to the 
CodingStyle.

>   	if (IS_ERR(async->cmd.chanlist)) {
>   		ret = PTR_ERR(async->cmd.chanlist);
>   		async->cmd.chanlist = NULL;
>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
