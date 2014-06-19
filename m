Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965979AbaFSVTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:19:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965706AbaFSVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:19:52 -0400
Date: Thu, 19 Jun 2014 14:19:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] init/do_mounts.c: treat EROFS like EACCES
Message-Id: <20140619141950.18b9026d7d06694291eea311@linux-foundation.org>
In-Reply-To: <1403107964-1082-1-git-send-email-phdm@macqel.be>
References: <1403107964-1082-1-git-send-email-phdm@macqel.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 18:12:44 +0200 Philippe De Muyter <phdm@macqel.be> wrote:

> some combinations of filesystem and block device (at least vfat on mmc)
> yield -EROFS instead of -EACCES when the device is read-only.  Retry
> mounting with MS_RDONLY set, just like for the EACCES case, instead of
> failing directly.
> 
> ...
>
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -394,6 +394,7 @@ retry:
>  			case 0:
>  				goto out;
>  			case -EACCES:
> +			case -EROFS:
>  				flags |= MS_RDONLY;
>  				goto retry;
>  			case -EINVAL:

hm, what's going on here.  I'd have thought it to be very logical that
file_system_type.mount() would return EROFS if the device is read-only!
But I'm suspecting that there is some convention that the fs is
supposed to return EACCES in this case.  So *perhaps* it is vfat-on-mmc
which needs fixing.  Dunno.

Al, are you able to shed light?

