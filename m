Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab3GaGLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:11:33 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:51737 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3GaGLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:11:31 -0400
Date: Wed, 31 Jul 2013 08:11:29 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS undeletable files. (3.11rc3)
Message-ID: <20130731061129.GA354@x4>
References: <20130712023930.GA6473@redhat.com>
 <20130725041538.GH13468@dastard>
 <20130730202628.GA16356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130730202628.GA16356@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.30 at 16:26 -0400, Dave Jones wrote:
> On Thu, Jul 25, 2013 at 02:15:38PM +1000, Dave Chinner wrote:
>  > On Thu, Jul 11, 2013 at 10:39:30PM -0400, Dave Jones wrote:
>  > > Just saw this during boot after an unclean shutdown. It hung afterwards.
>  > > 
>  > > [   97.162665] XFS: Assertion failed: xfs_dir2_sf_lookup(args) == ENOENT, file: fs/xfs/xfs_dir2_sf.c, line: 358
>  > > [   97.164646] ------------[ cut here ]------------
>  > 
>  > I just reproduced this by chance. I know exactly what I was doing
>  > when it went bang, so I might be able to reduce it from scattergun
>  > blast testing to be able to reproduce it on demand.
> 
> I xfs_repair'd that disk a week or so back, and have been fine until today when..
> 
> (16:22:57:root@zerosum:tmp.6)# ll
> ls: cannot access : No such file or directory
> total 0
> ?????????? ? ? ? ?            ? ?
> (16:22:58:root@zerosum:tmp.6)# cd ..
> (16:23:06:root@zerosum:tmp)# rm -rf tmp.6
> rm: cannot remove ‘tmp.6’: Directory not empty
> (16:23:14:root@zerosum:tmp)# cd -
> /home/davej/src/trinity/tmp/tmp.6
> (16:23:23:root@zerosum:tmp.6)# stat *
> stat: cannot stat ‘\020’: No such file or directory
> 
> I don't know if this is residual crap from that first problem that never got fixed up,
> or something new.
> 
> Any ideas ?

If you have crashed your test machine running an rc1 or rc2 kernel, you
must run xfs_repair again to clean up possible corruption (that happened
during log replay). The fix (commit e1b4271ac26) is in rc3.

-- 
Markus
