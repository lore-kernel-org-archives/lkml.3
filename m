Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab3EaRLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:11:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3EaRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:10:57 -0400
Date: Fri, 31 May 2013 10:11:24 -0700
From: Greg KH <greg@kroah.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        linux-s390@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] clean up scary strncpy(dst, src, strlen(src)) uses
Message-ID: <20130531171124.GB14699@kroah.com>
References: <20130531161807.GA9536@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531161807.GA9536@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 09:18:07AM -0700, Kees Cook wrote:
> Fix various weird constructions of strncpy(dst, src, strlen(src)). Length
> limits should be about the space available in the destination, not
> repurposed as a method to either always include or always exclude
> a trailing NULL byte. Either the NULL should always be copied
> (using strlcpy), or it should not be copied (using something like
> memcpy). Readable code should not depend on the weird behavior of strncpy
> when it hits the length limit. Better to avoid the anti-pattern entirely.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This is a follow-up to the anti-pattern being fixed in iscsi-target,
> which was exploitable:
> "iscsi-target: fix heap buffer overflow on error"
> http://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?id=cea4dcfdad926a27a18e188720efe0f2c9403456
> ---
>  Documentation/accounting/getdelays.c             |    3 ++-
>  drivers/acpi/sysfs.c                             |    3 +--
>  drivers/s390/net/qeth_l3_sys.c                   |    6 ++----
>  drivers/staging/tidspbridge/rmgr/drv_interface.c |    3 +--

For the drivers/staging/ part of this:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

