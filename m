Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808Ab3DDAQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:16:50 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54239 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3DDAQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:16:49 -0400
Date: Thu, 4 Apr 2013 09:16:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH] sysfs: fix crash_notes_size build warning
Message-ID: <20130404001644.GB29678@verge.net.au>
References: <201304031518.24455.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304031518.24455.arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 03:18:24PM +0000, Arnd Bergmann wrote:
> From b60d17603df3225d9f51c4f8168e8e00a1090911 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Wed, 3 Apr 2013 17:14:32 +0200
> Subject: [PATCH] sysfs: fix crash_notes_size build warning
> 
> commit eca4549f57 "sysfs: Add crash_notes_size to export percpu
> note size" adds a printk that outputs a size_t value as %lu
> when it should be %zu, resulting in this warning.
> 
> drivers/base/cpu.c: In function 'show_crash_notes_size':
> drivers/base/cpu.c:142:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat=]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Sorry for letting that slip through.

Acked-by: Simon Horman <horms@verge.net.au>

> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index a55b590..d8c7f3e 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -139,7 +139,7 @@ static ssize_t show_crash_notes_size(struct device *dev,
>  {
>  	ssize_t rc;
>  
> -	rc = sprintf(buf, "%lu\n", sizeof(note_buf_t));
> +	rc = sprintf(buf, "%zu\n", sizeof(note_buf_t));
>  	return rc;
>  }
>  static DEVICE_ATTR(crash_notes_size, 0400, show_crash_notes_size, NULL);
> 
