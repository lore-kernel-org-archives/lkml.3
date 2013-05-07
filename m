Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab3EGMUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab3EGMUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:20:10 -0400
Date: Tue, 7 May 2013 14:19:54 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@us.ibm.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Juan Quintela <quintela@redhat.com>, Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 0/4] madvise(MADV_USERFAULT) &
 sys_remap_anon_pages()
Message-ID: <20130507121954.GE12538@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
 <20130507113809.GB10720@hawk.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507113809.GB10720@hawk.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 01:38:10PM +0200, Andrew Jones wrote:
> What about instead of adding a new syscall (remap_anon_pages) to
> instead extend mremap with new flags giving it a strict mode?

I actually thought about this and it's a very interesting argument.

When I thought about it, I felt the problem was that we won't know
until we did some work (at least until reaching _each_ individual page
structure of every page mapped in the mremapped range) if we can avoid
the vma mangling or not. So then remap_anon_pages should be more
efficient because it will just error out if strict mode is not
possible, it won't need to search all page structures before it know
if it has to do the vma mangling or not.

It likely is simpler too than to try to teach mremap to do both things
after checking which one it can do.

Also, the same argument could be made about remap_file_pages too.

But it's still an interesting point, let's see what others thinks
about it.
