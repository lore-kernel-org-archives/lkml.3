Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCFJUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:20:15 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:43632 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaCFJUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:20:11 -0500
Message-ID: <53183D58.4040507@mev.co.uk>
Date: Thu, 6 Mar 2014 09:18:16 +0000
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Fred Akers <knivey@botops.net>
CC: "greg@kroah.com" <greg@kroah.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Staging: comedi: range: remove unnecessary sanity
 check
References: <20140306062333.GA19862@kroah.com> <1394089039-12408-2-git-send-email-knivey@botops.net>
In-Reply-To: <1394089039-12408-2-git-send-email-knivey@botops.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 06:57, Fred Akers wrote:
> This check is unnecessary because range_table will always be
> initialized to range_unknown by comedi_device_postconfig() for
> drivers that do not initialize range_table or range_table_list
>
> Signed-off-by: Fred Akers <knivey@botops.net>
> ---
>   drivers/staging/comedi/range.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
> index c4bb13b..b684954 100644
> --- a/drivers/staging/comedi/range.c
> +++ b/drivers/staging/comedi/range.c
> @@ -143,10 +143,6 @@ int comedi_check_chanlist(struct comedi_subdevice *s, int n,
>   	unsigned int chanspec;
>   	int chan, range_len, i;
>
> -	if (!s->range_table && !s->range_table_list) {
> -		dev_err(dev->class_dev, "(bug) no range type list!\n");
> -		return -EINVAL;
> -	}
>   	for (i = 0; i < n; i++) {
>   		chanspec = chanlist[i];
>   		chan = CR_CHAN(chanspec);
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

(Further down this `for` loop, the NULL-ness test on 
`s->range_table_list` is also technically redundant, but I think the 
code is clearer with the check left in, and is safer in a defensive way.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
