Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaGHCI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:08:29 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52119 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaGHCI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:08:27 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s6828BIk023765, This message is accepted by code: ctloc85258
Message-ID: <53BB53BE.3040208@realsil.com.cn>
Date: Tue, 8 Jul 2014 10:13:18 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabio Falzoi <fabio.falzoi84@gmail.com>, <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <joe@perches.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v2 4/4] Staging: rts5208: Fix a format specifier for dev_err
References: <1404717004-29540-1-git-send-email-fabio.falzoi84@gmail.com> <1404717004-29540-5-git-send-email-fabio.falzoi84@gmail.com>
In-Reply-To: <1404717004-29540-5-git-send-email-fabio.falzoi84@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 03:10 PM, Fabio Falzoi wrote:
> Fix an incorrect use of the %d format specifier in dev_err that caused a
> warning.
>
> Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
> ---
>   drivers/staging/rts5208/rtsx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
> index 4f5f7a3..9aae7ac 100644
> --- a/drivers/staging/rts5208/rtsx.c
> +++ b/drivers/staging/rts5208/rtsx.c
> @@ -463,14 +463,14 @@ static int rtsx_control_thread(void *__dev)
>   		 * the maximum known LUN
>   		 */
>   		else if (chip->srb->device->id) {
> -			dev_err(&dev->pci->dev, "Bad target number (%d:%d)\n",
> +			dev_err(&dev->pci->dev, "Bad target number (%d:%llu)\n",
here exist some compile warning.
drivers/staging/rts5208/rtsx.c:468:5: warning: format ‘%llu’ expects 
argument of type ‘long long unsigned int’, but argument 4 has type 
‘unsigned int’ [-Wformat]

>   				chip->srb->device->id,
>   				chip->srb->device->lun);
>   			chip->srb->result = DID_BAD_TARGET << 16;
>   		}
>   
>   		else if (chip->srb->device->lun > chip->max_lun) {
> -			dev_err(&dev->pci->dev, "Bad LUN (%d:%d)\n",
> +			dev_err(&dev->pci->dev, "Bad LUN (%d:%llu)\n",
>   				chip->srb->device->id,
>   				chip->srb->device->lun);
>   			chip->srb->result = DID_BAD_TARGET << 16;

