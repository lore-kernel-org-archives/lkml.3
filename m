Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3EMN7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:59:33 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:55215 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3EMN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:59:30 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, EUNBONG SONG <eunb.song@samsung.com>,
        "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs\@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: EXT4 regression caused 4eec7
In-Reply-To: <20130513135221.GE4845@thunk.org>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17> <20130513131809.GG400@quack.suse.cz> <20130513133036.GB4845@thunk.org> <87bo8fxa92.fsf@openvz.org> <20130513135221.GE4845@thunk.org>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 13 May 2013 17:59:25 +0400
Message-ID: <878v3jx9oi.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 09:52:21 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, May 13, 2013 at 05:47:05PM +0400, Dmitry Monakhov wrote:
> > In fact generic/299 always succeed for me, but it produce warning
> > WARNING: at fs/ext4/inode.c:3218 ext4_ext_direct_IO
> > and complains from slab debug. But it was missed because i've missed
> > this error in the logs and forget to check /proc/sys/kernel/tained.
> 
> This is how it's failing for me....
Because you ask questions, but do not read answers :)
http://marc.info/?l=linux-ext4&m=136580060822252&w=2
http://marc.info/?l=linux-ext4&m=136610044500931&w=2
> 
> generic/299		[23:06:27][  109.243220] fio (3376) used greatest stack depth: 5240 bytes left
> [  109.252757] fio (3380) used greatest stack depth: 5140 bytes left
> [  109.307227] fio (3374) used greatest stack depth: 4944 bytes left
>  [23:08:10] [failed, exit status 1] - output mismatch (see /root/xfstests/results/generic/299.out.bad)
>     --- tests/generic/299.out	2013-04-05 21:41:17.000000000 -0400
>     +++ /root/xfstests/results/generic/299.out.bad	2013-05-11 23:08:10.835356876 -0400
>     @@ -3,3 +3,6 @@
>      Run fio with random aio-dio pattern
>      
>      Start fallocate/truncate loop
>     +./common/rc: line 2055:  3335 Segmentation fault      "$@" >> $seqres.full 2>&1
>     +failed: '/root/xfstests/bin/fio /tmp/3135-299.fio'
>     +(see /root/xfstests/results/generic/299.full for details)
>      ...
>      (Run 'diff -u tests/generic/299.out /root/xfstests/results/generic/299.out.bad' to see the entire diff)
> 
> I haven't had a chance to investigate the core dump yet....
> 
>   	      	       	  	      	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
