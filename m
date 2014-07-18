Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbaGRPV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:21:58 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:47315 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaGRPV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:21:57 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1405365496-58404-2-git-send-email-seth.forshee@canonical.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
	<1405365496-58404-2-git-send-email-seth.forshee@canonical.com>
Date: Fri, 18 Jul 2014 17:21:55 +0200
Message-ID: <CAJfpegt7BRgnHZWR8TbgnXx7+Xey3CS98i1UUdjm4C2G1u6RGg@mail.gmail.com>
Subject: Re: [PATCH 1/3] fuse/dev: Fix unbalanced calls to kunmap_atomic()
 during splice I/O
From: Miklos Szeredi <miklos@szeredi.hu>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 9:18 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> fuse_copy_finish() assumes that mapaddr in fuse_copy_state refers
> to a valid mapping if currbuf is non-NULL, but this isn't always
> true when moving pages for splice I/O. This results in an
> unbalanced call to kunmap_atomic() and thus an unbalanced
> decrement of the preempt count. Avoid this by checking that
> mapaddr is non-NULL before calling kunmap_atomic().

I guess this is obsoleted by:

  c55a01d360af  fuse: avoid scheduling while atomic

which moves the kmap/kunmap closer to the actual use of the mapping.

Can you please verify?

Thanks,
Miklos
