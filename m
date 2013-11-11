Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3KKXHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:07:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:33227 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3KKXHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:07:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,680,1378882800"; 
   d="scan'208";a="425858059"
Message-ID: <52816423.8080501@linux.intel.com>
Date: Mon, 11 Nov 2013 15:11:31 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Michal Nazarewicz <mpn@google.com>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 1/2] usb: gadget: f_fs: remove loop from I/O function
References: <1383603177-4624-4-git-send-email-david.a.cohen@linux.intel.com> <1384102237-19784-1-git-send-email-mpn@google.com>
In-Reply-To: <1384102237-19784-1-git-send-email-mpn@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 11/10/2013 08:50 AM, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> When endpoint changes (due to it being disabled or alt setting changed),
> mimic the action as if the change happened after the request has been
> queued, instead of retrying with the new endpoint.
>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>   drivers/usb/gadget/f_fs.c | 94 +++++++++++++++++++++--------------------------
>   1 file changed, 41 insertions(+), 53 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index 44cf775..f875f26 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -754,74 +754,61 @@ static ssize_t ffs_epfile_io(struct file *file,
>   {
>   	struct ffs_epfile *epfile = file->private_data;
>   	struct ffs_ep *ep;
> -	char *data = NULL;
>   	ssize_t ret;
> +	char *data;

You can't non-initialize data, otherwise we'll end up with this correct
warning:
drivers/usb/gadget/f_fs.c:866:7: warning: 'data' may be used 
uninitialized in this function [-Wmaybe-uninitialized]

If you agree, you can send v5.1 to my 5th patch set (or let me handle
it).

Br, David
