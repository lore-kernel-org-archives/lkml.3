Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684Ab3DIJ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:57:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39132 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab3DIJ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:57:42 -0400
Message-ID: <5163E603.3030103@ti.com>
Date: Tue, 9 Apr 2013 15:27:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v3 2/3] media: davinci: vpbe: venc: move the enabling
 of vpss clocks to driver
References: <1365423553-12619-1-git-send-email-prabhakar.csengg@gmail.com> <1365423553-12619-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1365423553-12619-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 4/8/2013 5:49 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> The vpss clocks were enabled by calling a exported function from a driver
> in a machine code. calling driver code from platform code is incorrect way.
> 
> This patch fixes this issue and calls the function from driver code itself.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpbe_venc.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
> index f15f211..91d0272 100644
> --- a/drivers/media/platform/davinci/vpbe_venc.c
> +++ b/drivers/media/platform/davinci/vpbe_venc.c
> @@ -202,6 +202,25 @@ static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
>  	}
>  }
>  
> +static void
> +venc_enable_vpss_clock(int venc_type,
> +		       enum vpbe_enc_timings_type type,
> +		       unsigned int pclock)
> +{
> +	if (venc_type == VPBE_VERSION_1)
> +		return;
> +
> +	if (venc_type == VPBE_VERSION_2 && (type == VPBE_ENC_STD ||
> +	    (type == VPBE_ENC_DV_TIMINGS && pclock <= 27000000))) {

checkpatch --strict will throw a "Alignment should match open
parenthesis" check here. You may want to fix before you send the pull
request. No need to resend the patch just for this.

Thanks,
Sekhar
