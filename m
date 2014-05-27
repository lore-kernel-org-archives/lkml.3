Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaE0SgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:36:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34996 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaE0SgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:36:11 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Heesub Shin <heesub.shin@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] staging: ion: remove struct page_info
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
	<1401098701-24049-6-git-send-email-heesub.shin@samsung.com>
Date: Tue, 27 May 2014 11:36:07 -0700
In-Reply-To: <1401098701-24049-6-git-send-email-heesub.shin@samsung.com>
	(Heesub Shin's message of "Mon, 26 May 2014 19:04:58 +0900")
Message-ID: <vnkw61kr5aso.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26 2014 at 03:04:58 AM, Heesub Shin <heesub.shin@samsung.com> wrote:
> ION system heap uses a temporary list holding meta data on pages
> allocated to build scatter/gather table. Now that the pages are compound
> pages, we do not need to introduce a new data type redundantly.
>
> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
> ---
>  drivers/staging/android/ion/ion_system_heap.c | 47 +++++++++------------------
>  1 file changed, 15 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index 73a2e67..f0ae210 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -51,11 +51,6 @@ struct ion_system_heap {
>  	struct ion_page_pool **pools;
>  };
>  
> -struct page_info {
> -	struct page *page;
> -	struct list_head list;
> -};
> -
>  static struct page *alloc_buffer_page(struct ion_system_heap *heap,
>  				      struct ion_buffer *buffer,
>  				      unsigned long order)
> @@ -96,19 +91,14 @@ static void free_buffer_page(struct ion_system_heap *heap,
>  }
>  
>  
> -static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
> -						 struct ion_buffer *buffer,
> -						 unsigned long size,
> -						 unsigned int max_order)
> +static struct page *alloc_largest_available(struct ion_system_heap *heap,
> +					    struct ion_buffer *buffer,
> +					    unsigned long size,
> +					    unsigned int max_order)

Was this whitespace-only change intentional?


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
