Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3EZOrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:47:10 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:54559 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3EZOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:47:08 -0400
Message-ID: <51A22068.6000605@cogentembedded.com>
Date: Sun, 26 May 2013 18:47:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] media: davinci: vpif_capture: move the freeing
 of irq and global variables to remove()
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com> <1369569612-30915-5-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1369569612-30915-5-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-05-2013 16:00, Prabhakar Lad wrote:

> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

> Ideally the freeing of irq's and the global variables needs to be
> done in the remove() rather than module_exit(), this patch moves
> the freeing up of irq's and freeing the memory allocated to channel
> objects to remove() callback of struct platform_driver.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>   drivers/media/platform/davinci/vpif_capture.c |   31 ++++++++++--------------
>   1 files changed, 13 insertions(+), 18 deletions(-)

> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index caaf4fe..f8b7304 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -2225,17 +2225,29 @@ vpif_int_err:
>    */
>   static int vpif_remove(struct platform_device *device)
>   {
> -	int i;
> +	struct platform_device *pdev;
>   	struct channel_obj *ch;
> +	struct resource *res;
> +	int irq_num, i = 0;
> +
> +	pdev = container_of(vpif_dev, struct platform_device, dev);

    Why you need this if you should be already called with the correct 
platform device?

WBR, Sergei

