Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3ENFdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab3ENFdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:33:42 -0400
Message-ID: <1368509609.2507.8.camel@cr0>
Subject: Re: [Patch] quota: do not leak info to user-space
From: Cong Wang <amwang@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        xfs@oss.sgi.com
Date: Tue, 14 May 2013 13:33:29 +0800
In-Reply-To: <20130513101839.GE400@quack.suse.cz>
References: <1368177873-4819-1-git-send-email-amwang@redhat.com>
	 <20130513100423.GD400@quack.suse.cz> <20130513101839.GE400@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 12:18 +0200, Jan Kara wrote:
> On Mon 13-05-13 12:04:23, Jan Kara wrote:
> > On Fri 10-05-13 17:24:33, Cong Wang wrote:
> > > From: Cong Wang <amwang@redhat.com>
> > > 
> > > There is a hole in struct fs_quota_stat, so we have to
> > > zero the struct on stack before copying it to user-space.
> > > 
> > > Cc: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Cong Wang <amwang@redhat.com>
> >   Good point. I've merged the patch.
>   Ah, now I've noticed that XFS (the only user of the callback you are
> fixing) is zeroing the structure on its own (xfs_qm_scall_getqstat). So
> there's no real problem. I'm somewhat wondering whether clearing the field
> in the place where you did it isn't more future-proof but usually we don't
> pass in prezeroed buffers so I've decided to leave things as they are.
> 

You are right. Thanks for looking into this!


