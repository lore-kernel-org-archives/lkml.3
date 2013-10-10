Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3JJGPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:15:39 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:57568 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JJGPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:15:38 -0400
Date: Thu, 10 Oct 2013 01:15:34 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Squashfs: Refactor decompressor interface and code
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, minchan@kernel.org,
        Phillip Lougher <phillip@squashfs.org.uk>
In-Reply-To: <1381198450-2202-1-git-send-email-phillip@squashfs.org.uk>
	(from phillip@squashfs.org.uk on Mon Oct  7 21:14:10 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381385734.1974.183@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 09:14:10 PM, Phillip Lougher wrote:
> The decompressor interface and code was written from
> the point of view of single-threaded operation.  In doing
> so it mixed a lot of single-threaded implementation specific
> aspects into the decompressor code and elsewhere which makes it
> difficult to seamlessly support multiple different decompressor
> implementations.
...
>  11 files changed, 237 insertions(+), 136 deletions(-)

It sounds like this is mostly refactoring, but it adds 100 lines of  
code? Let's see, new function prototypes in the header, new #includes  
in the added C file...

Ah, here's the biggest chunk: a new instance of the FSF boilerplate  
telling you to go to 51 Franklin Street to pick up a physical copy of  
GPLv3 and try to figure out how it's relevant to Linux:

> --- /dev/null
> +++ b/fs/squashfs/decompressor_single.c
> @@ -0,0 +1,107 @@
> +/*
> + * Squashfs - a compressed read only filesystem for Linux
> + *
> + * Copyright (c) 2013
> + * Phillip Lougher <phillip@squashfs.org.uk>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2,
> + * or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  
> 02110-1301, USA.
> + *
> + * decompressor_single.c
> + */

*shrug* Mostly just curious...

Rob