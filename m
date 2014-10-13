Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaJMJOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:14:44 -0400
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:49570 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbaJMJOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:14:41 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <543B97FA.8050207@mev.co.uk>
Date: Mon, 13 Oct 2014 10:14:34 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: comedi_bond.c:  Changed from
 using strncat to strlcat
References: <1413116604-18554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1413116604-18554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/14 13:23, Rickard Strandqvist wrote:
> Changed from using strncat to strlcat to simplify the code
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/comedi_bond.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
> index 8450c99..5d19861 100644
> --- a/drivers/staging/comedi/drivers/comedi_bond.c
> +++ b/drivers/staging/comedi/drivers/comedi_bond.c
> @@ -262,12 +262,10 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
>   			{
>   				/* Append dev:subdev to devpriv->name */
>   				char buf[20];
> -				int left =
> -				    MAX_BOARD_NAME - strlen(devpriv->name) - 1;
>   				snprintf(buf, sizeof(buf), "%u:%u ",
>   					 bdev->minor, bdev->subdev);
> -				buf[sizeof(buf) - 1] = 0;
> -				strncat(devpriv->name, buf, left);
> +				strlcat(devpriv->name, buf,
> +					sizeof(devpriv->name));
>   			}
>
>   		}
>

Looks good.  Additionally, the #define MAX_BOARD_NAME could be 
eliminated as now it is only used to to set the length of the 'name' 
member in 'struct comedi_bond_private'.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
