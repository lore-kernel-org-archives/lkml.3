Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3LMRn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:43:26 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49103 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3LMRnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:43:25 -0500
Message-ID: <52AB4739.4010006@linux.com>
Date: Fri, 13 Dec 2013 18:43:21 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yu Chen <chyyuu@gmail.com>
CC: linux-kernel@vger.kernel.org, megaraidlinux@lsi.com,
        xiaoqixue_1 <xiaoqixue_1@163.com>,
        =?UTF-8?B?6IyD5paH6Imv?= <fanwlexca@gmail.com>
Subject: Re: [PATCH] scsi: integer overflow in megadev_ioctl()
References: <CAAdffVGw9Fz1AzAWs5y2943R3JsTvaCvQN1kipCdpeK+Guv_JQ@mail.gmail.com>	<52AB3D86.2040706@linux.com> <CAAdffVHtRc4Ew9f8DMdQf7jC3+saSg1V6OVoAChhMN2WpCo2OA@mail.gmail.com>
In-Reply-To: <CAAdffVHtRc4Ew9f8DMdQf7jC3+saSg1V6OVoAChhMN2WpCo2OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 06:31 PM, Yu Chen wrote:
> Thank you!  The new patch
> -------------------------------------------------------------
> [PATCH] scsi: integer overflow in megadev_ioctl()
> 
> There is a potential integer overflow in megadev_ioctl() if
> userspace passes in a large u32 variable uioc.adapno.
> Theint variable adapno would < 0, leading to a error
Typo here, 'theint' should be 'the int'
also it should be 'an error' instead of 'a error'

> array access for hdb_soft_state[adapno], or a error
Here as well.

> copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,..)
> 
> Reported-by: Wenliang Fan <fanwlexca@gmail.com>
> Suggested-by: Qixue Xiao <xiaoqixue_1@163.com>
> Signed-off-by: Yu Chen <chyyuu@gmail.com>
Reviewed-by: Levente Kurusa <levex@linux.com>

(Once you have fixed my suggestions :-) )

> ---
>  drivers/scsi/megaraid.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 41bbc21..0b90c54 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -3099,7 +3099,10 @@ megadev_ioctl(struct file *filep, unsigned int
> cmd, unsigned long arg)
>   /*
>   * Which adapter
>   */
> - if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
> + adapno = GETADAP(uioc.adapno);
> + if( adapno < 0 )
> + return (-EINVAL);
> + if( adapno >= hba_count )
>   return (-ENODEV);
> 
>   if( copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,


Total whitespace damage. :-)

Try sending them with 'git send-email' or configure your email client
properly.

Oh, and one last thing. Don't post the v3 as a reply to this, but
instead as a whole new post.

-- 
Regards,
Levente Kurusa
