Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaCTLD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:03:58 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51706 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTLD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:03:56 -0400
Date: Thu, 20 Mar 2014 15:03:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] proc: show mnt_id in fdinfo files (v2)
Message-ID: <20140320110352.GQ1728@moon>
References: <1395313048-12072-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395313048-12072-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:57:28PM +0400, Andrey Vagin wrote:
> Currently we don't have a way how to determing from which mount point
> file has been opened. This information is required for proper dumping
> and restoring file descriptos due to presence of mount namespaces. It's
> possible, that two file descriptors are opened using the same paths, but
> one fd references mount point from one namespace while the other fd --
> from other namespace.
> 
> $ ls -l /proc/1/fd/1
> lrwx------ 1 root root 64 Mar 19 23:54 /proc/1/fd/1 -> /dev/null
> 
> $ cat /proc/1/fdinfo/1
> pos:	0
> flags:	0100002
> mnt_id:	16
> 
> $ cat /proc/1/mountinfo | grep ^16
> 16 32 0:4 / /dev rw,nosuid shared:2 - devtmpfs devtmpfs rw,size=1013356k,nr_inodes=253339,mode=755
> 
> v2: update Documentation/filesystems/proc.txt
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Rob Landley <rob@landley.net>
> Acked-by: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
