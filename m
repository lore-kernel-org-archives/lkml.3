Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaGGQaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:30:08 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60385 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:30:06 -0400
Date: Mon, 7 Jul 2014 18:30:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sebastien Buisson <sebastien.buisson@bull.net>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-ID: <20140707163003.GA18735@two.firstfloor.org>
References: <53B667F9.90306@bull.net>
 <87y4w6sbp7.fsf@tassilo.jf.intel.com>
 <53BA772C.6040506@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BA772C.6040506@bull.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/fs/Kconfig b/fs/Kconfig
> index c229f82..c08844c 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -268,4 +268,13 @@ endif # NETWORK_FILESYSTEMS
>  source "fs/nls/Kconfig"
>  source "fs/dlm/Kconfig"
> 
> +config BH_LRU_SIZE
> +      int
> +      range 8 64
> +      default "16"

So who sets it then? 

You need it for ext4 and quota right? So this combination
should set it at least. Something like (unested)

It would be also good to audit or test other file systems if they need the
same if that's possible.

config BH_LARGE_LRU
	bool
	depends on (EXT4_FS && QUOTA)

config BH_LRU_SIZE
....
	default "16" if BH_LARGE_LRU
	default "8" if !BH_LARGE_LRU

-Andi
