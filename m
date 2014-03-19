Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaCSXW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:22:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaCSXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:22:26 -0400
Date: Wed, 19 Mar 2014 16:22:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Andrey Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] proc: show mnt_id in fdinfo files
Message-Id: <20140319162225.81388fb08ae413ded0abc14e@linux-foundation.org>
In-Reply-To: <20140317115013.GA26250@moon>
References: <1395052750-8525-1-git-send-email-avagin@openvz.org>
	<5326DCD2.1040303@parallels.com>
	<20140317115013.GA26250@moon>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 15:50:13 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Mon, Mar 17, 2014 at 03:30:26PM +0400, Pavel Emelyanov wrote:
> > On 03/17/2014 02:39 PM, Andrey Vagin wrote:
> > > Currently we don't have a way how to determing from which mount point
> > > file has been opened. This information is required for proper dumping
> > > and restoring file descriptos due to presence of mount namespaces. It's
> > > possible, that two file descriptors are opened using the same paths, but
> > > one fd references mount point from one namespace while the other fd --
> > > from other namespace.
> > > 
> > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > > Cc: Pavel Emelyanov <xemul@parallels.com>
> > > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> > 
> > These IDs are already shown in the /proc/$pid/mountinfo, and for some FSs
> > can be obtained via path_to_handle_at(), so this patch just makes it work
> > for any FS and speeds things up.
> > 
> > Acked-by: Pavel Emelyanov <xemul@parallels.com>
> 
> I think Documentation/filesystems/proc.txt should be updated on top.

Yes please.

It would be nice to see example output in the changelog as well please.
