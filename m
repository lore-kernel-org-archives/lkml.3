Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaESVYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:24:32 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:62539 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaESVYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:24:30 -0400
Message-ID: <537A768C.8080807@cogentembedded.com>
Date: Tue, 20 May 2014 01:24:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Karsten Keil <isdn@linux-pingi.de>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: l3dss1.c:  Fix for possible null pointer
 dereference
References: <1400347101-25476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400347101-25476-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/17/2014 09:18 PM, Rickard Strandqvist wrote:

> There is otherwise a risk of a possible null pointer dereference.

> Was largely found by using a static code analysis program called cppcheck.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/isdn/hisax/l3dss1.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)

> diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
> index cda7006..3ea6257 100644
> --- a/drivers/isdn/hisax/l3dss1.c
> +++ b/drivers/isdn/hisax/l3dss1.c
> @@ -2208,8 +2208,12 @@ static int l3dss1_cmd_global(struct PStack *st, isdn_ctrl *ic)
>   				{ free_invoke_id(st, id);
>   					return (-2);
>   				}
> -			pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
> -			pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
> +
> +			if (pc)
> +			{

    { sould be on the same line as *if*.

> +				pc->prot.dss1.ll_id = ic->parm.dss1_io.ll_id; /* remember id */
> +				pc->prot.dss1.proc = ic->parm.dss1_io.proc; /* and procedure */
> +			}

WBR, Sergei

