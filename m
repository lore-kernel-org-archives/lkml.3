Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaCCUzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:55:11 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:52285 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241AbaCCUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:55:09 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsRAOPrFFNbslH8/2dsb2JhbABaKIJeg0O+KAICgSUXdIIlAQEEAScTHCMFCwgDGC45HgYTh3EMAcxVF44CVweEOASJSY5yAYpUh1eDOi+BLQ
Date: Mon, 3 Mar 2014 20:56:24 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] affs: AFFS_NO_TRUNCATE added to Kconfig
Message-Id: <20140303205624.0943baeea9590b81bfb069a8@skynet.be>
In-Reply-To: <20140303194327.GA22359@redhat.com>
References: <20140303182218.bc1de22e2c404dd1e07553b4@skynet.be>
	<20140303194327.GA22359@redhat.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014 14:43:27 -0500
Dave Jones <davej@redhat.com> wrote:

> On Mon, Mar 03, 2014 at 06:22:18PM +0800, Fabian Frederick wrote:
>  > Filename truncate process is defined in affs.h.
>  > 
>  > This patch exports current define to Kconfig and removes
>  > AFFS_MAX_PREALLOC which is never used.
>  > +
>  > +config AFFS_NO_TRUNCATE
>  > +	bool "Amiga FFS no filename truncate"
>  > +	depends on AFFS_FS
>  > +	default n
>  > +	help
>  > +	  If you say Y here, creating filesystem objects with longer names than
>  > +	  30 characters (standard limit) will result in an error (ENAMETOOLONG).
>  > +
>  > +	  By default this option is disabled and filenames are automatically
>  > +	  truncated.
> 
> I get the feeling this would be better as a mount option than a config option.
> Then again, the number of people still caring about AFFS is probably in
> single digits these days, so I doubt anyone would complain if this was set
> one way or the other in a distribution kernel.

Good idea but I guess this would need passing sbi->s_flags to affs_check_name which would require some more updates ...

Fabian

> 
> 	Dave
> 
