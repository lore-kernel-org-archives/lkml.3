Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbbA2PYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:24:52 -0500
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:40956 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbbA2PYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:24:50 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA50BC.8030403@mev.co.uk>
Date: Thu, 29 Jan 2015 15:24:44 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: dyna_pci10xx: Removed variables
 that is never used
References: <1422484507-8925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484507-8925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 22:35, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/dyna_pci10xx.c |    5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
> index 1b6324c..8882423 100644
> --- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
> +++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
> @@ -115,10 +115,9 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
>   {
>   	struct dyna_pci10xx_private *devpriv = dev->private;
>   	int n;
> -	unsigned int chan, range;
>
> -	chan = CR_CHAN(insn->chanspec);
> -	range = range_codes_pci1050_ai[CR_RANGE((insn->chanspec))];
> +	CR_CHAN(insn->chanspec);
> +	range_codes_pci1050_ai[CR_RANGE((insn->chanspec))];

Both those lines produce compiler warnings, are not needed, don't belong 
here and should be removed.  The AO subdevice has a single, fixed range.

>
>   	mutex_lock(&devpriv->mutex);
>   	for (n = 0; n < insn->n; n++) {
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
