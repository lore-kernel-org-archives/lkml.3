Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaGUMT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:19:59 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39527 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaGUMT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:19:57 -0400
Date: Mon, 21 Jul 2014 07:18:54 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 1/3] fuse/dev: Fix unbalanced calls to kunmap_atomic()
 during splice I/O
Message-ID: <20140721121854.GA111224@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.sourceforge.net>,
	lxc-devel@lists.linuxcontainers.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Michael H. Warfield" <mhw@wittsend.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
 <1405365496-58404-2-git-send-email-seth.forshee@canonical.com>
 <CAJfpegt7BRgnHZWR8TbgnXx7+Xey3CS98i1UUdjm4C2G1u6RGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt7BRgnHZWR8TbgnXx7+Xey3CS98i1UUdjm4C2G1u6RGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:21:55PM +0200, Miklos Szeredi wrote:
> On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > fuse_copy_finish() assumes that mapaddr in fuse_copy_state refers
> > to a valid mapping if currbuf is non-NULL, but this isn't always
> > true when moving pages for splice I/O. This results in an
> > unbalanced call to kunmap_atomic() and thus an unbalanced
> > decrement of the preempt count. Avoid this by checking that
> > mapaddr is non-NULL before calling kunmap_atomic().
> 
> I guess this is obsoleted by:
> 
>   c55a01d360af  fuse: avoid scheduling while atomic
> 
> which moves the kmap/kunmap closer to the actual use of the mapping.
> 
> Can you please verify?

Yes, that commit does seem to fix the problem.

