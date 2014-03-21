Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaCUE0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 00:26:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaCUE0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 00:26:15 -0400
Date: Thu, 20 Mar 2014 21:27:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: nandu.hgowda@gmail.com, devel@driverdev.osuosl.org, shaun@xresource.ca,
        gulsah.1004@gmail.com, sachin.kamat@linaro.org,
        peter.p.waskiewicz.jr@intel.com, ebru.akagunduz@gmail.com,
        dulshani.gunawardhana89@gmail.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, himangi774@gmail.com, viro@zeniv.linux.org.uk,
        joe@perches.com, fempsci@gmail.com, speiro@ai2.upv.es
Subject: Re: [PATCH v2] staging: cxt1e1: replace OS_kmalloc/OS_kfree with
 kmalloc/kfree
Message-ID: <20140321042737.GA4439@kroah.com>
References: <1983239.9vdN5jE4dT@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1983239.9vdN5jE4dT@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 01:15:23PM +0900, Daeseok Youn wrote:
> 
> Replace OS_kmalloc/OS_kfree with kmalloc/kfree.

You should replace it with kzalloc, not kmalloc, as OS_kmalloc() zeroed
out the allocated data:


> -static inline void *
> -OS_kmalloc (size_t size)
> -{
> -    char       *ptr = kmalloc (size, GFP_KERNEL | GFP_DMA);
> -
> -    if (ptr)
> -        memset (ptr, 0, size);
> -    return ptr;
> -}

greg k-h
