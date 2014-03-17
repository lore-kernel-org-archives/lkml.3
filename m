Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaCQLuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:50:21 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34536 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQLuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:50:19 -0400
Date: Mon, 17 Mar 2014 15:50:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] proc: show mnt_id in fdinfo files
Message-ID: <20140317115013.GA26250@moon>
References: <1395052750-8525-1-git-send-email-avagin@openvz.org>
 <5326DCD2.1040303@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5326DCD2.1040303@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 03:30:26PM +0400, Pavel Emelyanov wrote:
> On 03/17/2014 02:39 PM, Andrey Vagin wrote:
> > Currently we don't have a way how to determing from which mount point
> > file has been opened. This information is required for proper dumping
> > and restoring file descriptos due to presence of mount namespaces. It's
> > possible, that two file descriptors are opened using the same paths, but
> > one fd references mount point from one namespace while the other fd --
> > from other namespace.
> > 
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> 
> These IDs are already shown in the /proc/$pid/mountinfo, and for some FSs
> can be obtained via path_to_handle_at(), so this patch just makes it work
> for any FS and speeds things up.
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>

I think Documentation/filesystems/proc.txt should be updated on top.
Other than that

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
