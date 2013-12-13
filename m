Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab3LMRCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:02:09 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55141 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3LMRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:02:07 -0500
Message-ID: <52AB3D86.2040706@linux.com>
Date: Fri, 13 Dec 2013 18:01:58 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yu Chen <chyyuu@gmail.com>, linux-kernel@vger.kernel.org
CC: megaraidlinux@lsi.com, xiaoqixue_1 <xiaoqixue_1@163.com>,
        =?UTF-8?B?6IyD5paH6Imv?= <fanwlexca@gmail.com>
Subject: Re: [PATCH] scsi: integer overflow in megadev_ioctl()
References: <CAAdffVGw9Fz1AzAWs5y2943R3JsTvaCvQN1kipCdpeK+Guv_JQ@mail.gmail.com>
In-Reply-To: <CAAdffVGw9Fz1AzAWs5y2943R3JsTvaCvQN1kipCdpeK+Guv_JQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/13/2013 05:55 PM, Yu Chen wrote:
>  drivers/scsi/megaraid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 816db12..41bbc21 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -3113,7 +3113,8 @@ megadev_ioctl(struct file *filep, unsigned int
> cmd, unsigned long arg)
>   /*
>   * Which adapter
>   */
> - if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
> +                adapno = GETADAP(uioc.adapno);
> + if( adapno >= hba_count || adapno < 0 )
>   return (-ENODEV);

Wouldn't returning -EINVAL be better? For hba_count I understand that
-ENODEV is returned but for adapno being a passed variable, I would
suggest returning -EINVAL.

-- 
Regards,
Levente Kurusa
