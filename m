Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763028Ab3DCSHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:07:00 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56326 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762997Ab3DCSG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:06:58 -0400
Date: Wed, 3 Apr 2013 11:06:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: fix compile warning in i386
Message-ID: <20130403180656.GA7407@kroah.com>
References: <515BAE6E.4040502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515BAE6E.4040502@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 12:22:06PM +0800, Zhang Yanfei wrote:
> This patch fixes compile warning in i386:
> 
> drivers/base/cpu.c: In function 'show_crash_notes_size':
> drivers/base/cpu.c:142:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  drivers/base/cpu.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index a55b590..ee38cc2 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -138,8 +138,10 @@ static ssize_t show_crash_notes_size(struct device *dev,
>  				     char *buf)
>  {
>  	ssize_t rc;
> +	unsigned long size;
>  
> -	rc = sprintf(buf, "%lu\n", sizeof(note_buf_t));
> +	size = sizeof(note_buf_t);
> +	rc = sprintf(buf, "%lu\n", size);

No, use %z, like Arnd did in his patch, that makes it correct for all
arches.  I'll take his patch instead.

thanks,

greg k-h
