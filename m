Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3LRPew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:34:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3LRPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:34:51 -0500
Date: Wed, 18 Dec 2013 07:34:51 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH] drivers: base: Add prototype declaration in memory.c
Message-ID: <20131218153451.GA22228@kroah.com>
References: <20131218063953.GA3180@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131218063953.GA3180@rashika>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:09:53PM +0530, Rashika Kheria wrote:
> Add the prototype declaration of function memory_block_size_bytes() in
> memory.c.
> 
> This eliminates the following warning in memory.c:
> drivers/base/memory.c:87:1: warning: no previous prototype for ‘memory_block_size_bytes’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  drivers/base/memory.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index bece691..cfa03de 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -83,6 +83,7 @@ static void memory_block_release(struct device *dev)
>  	kfree(mem);
>  }
>  
> +unsigned long __weak memory_block_size_bytes(void);
>  unsigned long __weak memory_block_size_bytes(void)

If this patch is the "solution" then something else is really wrong
here, please use your judgement to realize this...

greg k-h
