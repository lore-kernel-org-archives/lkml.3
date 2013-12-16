Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3LPVka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:40:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3LPVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:40:27 -0500
Date: Mon, 16 Dec 2013 13:40:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 2/3] staging: ion: Fix possible null pointer
 dereference
Message-ID: <20131216214026.GA21685@kroah.com>
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
 <1387229564-19517-3-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387229564-19517-3-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 01:32:43PM -0800, John Stultz wrote:
> The kbuild test robot reported:
> 
> drivers/staging/android/ion/ion_system_heap.c:122 alloc_largest_available() error: potential null dereference 'info'.  (kmalloc returns null)
> 
> Where the pointer returned from kmalloc goes unchecked for failure.
> 
> This patch adds a simple check for a null return, and handles the error.
> 
> XXX: Not sure if continue or 'return NULL' is the right thing to do.
> 
> Cc: Colin Cross <ccross@android.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: kbuild test robot <fengguang.wu@intel.com>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/ion/ion_system_heap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index 144b2272..cc2e4da 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -119,6 +119,11 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
>  			continue;
>  
>  		info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
> +		if(!info) {

Please don't add new coding style issues to staging drivers, the goal is
to clean them up, not make more mess :)

Care to resend this when you have figured out the XXX: line above?

thanks,

greg k-h
