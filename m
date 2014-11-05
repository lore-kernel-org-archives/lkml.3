Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbaKEPSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:18:21 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39723 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaKEPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:18:19 -0500
Message-ID: <545A3FB8.5080004@plexistor.com>
Date: Wed, 05 Nov 2014 17:18:16 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/5 v4] brd: Add getgeo to block ops for fdisk
References: <545A2D69.8090003@plexistor.com> <545A2FEA.3050101@plexistor.com> <545A3EC8.3060203@plexistor.com>
In-Reply-To: <545A3EC8.3060203@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 05:14 PM, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
Sorry

[V4]
  Also fix the cryptic comment at the source code.

I have pushed new trees to the public tree as well

Thanks
Boaz

<>
> +static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
> +{
> +	/* With the usual emulated values of 64, 32, X and the
> +	 * default size of 4M device, fdisk will offer 40 as possible
> +	 * first-sector.
> +	 * But with the values presented here of 1, 1, 1 fdisk will
> +	 * offer 8 (4K) as possible first sector.
> +	 * Otherwise, either way, it effects nothing. Only fdisk calls
> +	 * this vector at all.
> +	 */
> +	geo->heads = 1;
> +	geo->sectors = 1;
> +	geo->cylinders = 1;
> +	return 0;
> +}
> +
>  static const struct block_device_operations brd_fops = {
>  	.owner =		THIS_MODULE,
>  	.rw_page =		brd_rw_page,
> @@ -433,6 +450,7 @@ static const struct block_device_operations brd_fops = {
>  #ifdef CONFIG_BLK_DEV_XIP
>  	.direct_access =	brd_direct_access,
>  #endif
> +	.getgeo =		brd_getgeo,
>  };
>  
>  /*
> 

