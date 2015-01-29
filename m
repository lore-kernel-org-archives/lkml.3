Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbbA2O0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:26:34 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:40855 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbbA2O0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:26:21 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA4309.4050807@mev.co.uk>
Date: Thu, 29 Jan 2015 14:26:17 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Vladimir A. Nazarenko" <naszar@ya.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: jr3_pci: Removed variables
 that is never used
References: <1422484546-9045-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484546-9045-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
>   drivers/staging/comedi/drivers/jr3_pci.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
> index 81fab2d..5d4cca7 100644
> --- a/drivers/staging/comedi/drivers/jr3_pci.c
> +++ b/drivers/staging/comedi/drivers/jr3_pci.c
> @@ -520,10 +520,9 @@ static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice
>   			result = poll_delay_min_max(20, 100);
>   		} else {
>   			/* Set full scale */
> -			struct six_axis_t min_full_scale;
>   			struct six_axis_t max_full_scale;
>
> -			min_full_scale = get_min_full_scales(channel);
> +			get_min_full_scales(channel);
>   			max_full_scale = get_max_full_scales(channel);
>   			set_full_scales(channel, max_full_scale);
>
>

Yes, it doesn't appear to be needed.  The driver used to have some 
kernel logs that output the min and max full scale information, but it 
didn't do anything else with min_full_scale.

The call to get_min_full_scales() and the function itself can also be 
removed.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
