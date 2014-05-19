Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaESV0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:26:55 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58773 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaESV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:26:53 -0400
Message-ID: <537A771C.2050808@cogentembedded.com>
Date: Tue, 20 May 2014 01:26:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Karsten Keil <isdn@linux-pingi.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: l3dss1.c:  Fix for possible null pointer
 dereference
References: <1400534662-5729-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400534662-5729-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 01:24 AM, Rickard Strandqvist wrote:

> There is otherwise a risk of a possible null pointer dereference.

> Was largely found by using a static code analysis program called cppcheck.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/isdn/hisax/l3dss1.c |   11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)

> diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
> index cda7006..9ea7377 100644
> --- a/drivers/isdn/hisax/l3dss1.c
> +++ b/drivers/isdn/hisax/l3dss1.c
> @@ -2203,13 +2203,14 @@ static int l3dss1_cmd_global(struct PStack *st, isdn_ctrl *ic)
>   			memcpy(p, ic->parm.dss1_io.data, ic->parm.dss1_io.datalen); /* copy data */
>   			l = (p - temp) + ic->parm.dss1_io.datalen; /* total length */
>
> -			if (ic->parm.dss1_io.timeout > 0)
> -				if (!(pc = dss1_new_l3_process(st, -1)))
> -				{ free_invoke_id(st, id);
> +			if (ic->parm.dss1_io.timeout > 0) {
> +				if (!(pc = dss1_new_l3_process(st, -1))) {

    Assignments shouldn't be put into *if* statement. If you did run the patch 
thru scripts/checkpatch.pl, it would have told you.

> +					free_invoke_id(st, id);
>   					return (-2);

    Parens not needed. Could as well fix it here...

>   				}
> -			pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
> -			pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
> +				pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
> +				pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
> +			}

WBR, Sergei


