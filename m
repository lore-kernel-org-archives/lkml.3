Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaDYQ1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:27:21 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41318 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaDYQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:27:17 -0400
Date: Fri, 25 Apr 2014 18:27:12 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: rw_copy_check_uvector() - free iov on error
Message-ID: <20140425162712.GH10187@tucsk.piliscsaba.szeredi.hu>
References: <20140415145749.GF10187@tucsk.piliscsaba.szeredi.hu>
 <20140416180422.GA20907@redhat.com>
 <20140421155020.GB13709@redhat.com>
 <CAJfpegs9cgVgxbYZSM=SxyJqj=N1QA5npp7ic6i80CMec+3sZw@mail.gmail.com>
 <20140422133835.GA32718@redhat.com>
 <20140423050639.GA2755@zzz.student-wireless07.macalester.edu>
 <20140423052534.GB2755@zzz.student-wireless07.macalester.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423052534.GB2755@zzz.student-wireless07.macalester.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:25:34AM -0500, Eric Biggers wrote:
> On Wed, Apr 23, 2014 at 12:06:39AM -0500, Eric Biggers wrote:
> > The proposed patch doesn't work because in compat_rw_copy_check_uvector(),
> > 'iov' is incremented in the loop before it is freed or returned.  This
> > probably should be changed to indexing with 'seg', like in the non-compat
> > version...
> 
> Also, there is still a memory leak in vmsplice() as it does not free the iov
> buffer if 0 is returned from rw_copy_check_uvector() (possible if all segments
> are of zero length).

There are more problems.  E.g. count is zero so nothing will be copied.  This
function needs some care and attention (and testing).

Thanks,
Miklos
