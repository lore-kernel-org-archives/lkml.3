Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaLRXMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:12:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaLRXMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:12:48 -0500
Date: Thu, 18 Dec 2014 15:12:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        ext4 development <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fs: make generic_block_fiemap sig-tolerant PING2...
Message-Id: <20141218151247.b6ccd73351f40db66818c07e@linux-foundation.org>
In-Reply-To: <87zjavehsx.fsf@openvz.org>
References: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org>
	<871toikt7c.fsf@openvz.org>
	<87zjavehsx.fsf@openvz.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014 16:49:18 +0300 Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> 
> Hello. Someone please take care of this patch.
> 
> W/o that patch unprivileged user may abuse system resources simply by spawning
> wast number of unkilable busyloops (works on ext2/ext3):
> 
> truncate --size 1T test
> for ((i=0;i<1024;i++))
> do
>        filefrag test > /dev/null &
> done
> 
> >> --- a/fs/ioctl.c
> >> +++ b/fs/ioctl.c
> >> @@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode *inode,
> >>  				past_eof = true;
> >>  		}
> >>  		cond_resched();
> >> +		if (fatal_signal_pending(current)) {
> >> +			ret = -EINTR;
> >> +			break;
> >> +		}
> >> +
> >>  	} while (1);
> >>  

Is FIEMAP documented anywhere (manpage)?  If so, that will need an
update.
