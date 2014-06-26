Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaFZIJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:09:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64158 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaFZIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:09:26 -0400
Message-ID: <53ABD51C.5050806@gmail.com>
Date: Thu, 26 Jun 2014 10:09:00 +0200
From: Jack Wang <xjtuwjp@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
CC: lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is
 set more than once
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Rickard,

>From my point of view, looks good, but I'd like to get review from Anand
(cc-ed).

Anand, could you share your opinion?

Regards,
Jack

On 06/25/2014 04:01 PM, Rickard Strandqvist wrote:
> A struct member variable is set to different values without having used in between.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index d70587f..2698227 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -249,7 +249,6 @@ moreData:
>  				sprintf(pm8001_ha->
>  					forensic_info.data_buf.direct_data,
>  						"%08x ", 4);
> -			pm8001_ha->forensic_info.data_buf.read_len = 0xFFFFFFFF;
>  			pm8001_ha->forensic_info.data_buf.direct_len =  0;
>  			pm8001_ha->forensic_info.data_buf.direct_offset = 0;
>  			pm8001_ha->forensic_info.data_buf.read_len = 0;
> 

