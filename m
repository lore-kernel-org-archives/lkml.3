Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3HVPed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:34:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37452 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563Ab3HVPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:34:32 -0400
X-Sasl-enc: CpDwbQc3CVlMlikOqfFzKbPEXPm4B8e4Q7fOfgwITibo 1377185670
Date: Thu, 22 Aug 2013 08:36:25 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20130822153625.GA5354@kroah.com>
References: <20130822153942.66d098b122092d6944186c53@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822153942.66d098b122092d6944186c53@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 03:39:42PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> In file included from include/linux/kobject.h:21:0,
>                  from include/linux/module.h:16,
>                  from drivers/acpi/bgrt.c:11:
> drivers/acpi/bgrt.c: In function 'bgrt_init':
> drivers/acpi/bgrt.c:89:23: error: 'image_attr' undeclared (first use in this function)
>   sysfs_bin_attr_init(&image_attr);
>                        ^
> include/linux/sysfs.h:53:3: note: in definition of macro 'sysfs_attr_init'
>   (attr)->key = &__key;    \
>    ^
> drivers/acpi/bgrt.c:89:2: note: in expansion of macro 'sysfs_bin_attr_init'
>   sysfs_bin_attr_init(&image_attr);
>   ^
> drivers/acpi/bgrt.c:89:23: note: each undeclared identifier is reported only once for each function it appears in
>   sysfs_bin_attr_init(&image_attr);
>                        ^
> include/linux/sysfs.h:53:3: note: in definition of macro 'sysfs_attr_init'
>   (attr)->key = &__key;    \
>    ^
> drivers/acpi/bgrt.c:89:2: note: in expansion of macro 'sysfs_bin_attr_init'
>   sysfs_bin_attr_init(&image_attr);
>   ^
> 
> Presumably caused by commit 65f44679580d ("ACPI: bgrt: take advantage of
> binary sysfs groups").

It's as if I never even built the patch I submitted, I have no idea what
happened here, sorry about that.

I've now fixed it up, it should be fine for the next linux-next release.

thanks,

greg k-h
