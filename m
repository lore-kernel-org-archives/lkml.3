Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3BLV6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:58:14 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49111 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3BLV6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:58:13 -0500
Date: Tue, 12 Feb 2013 13:58:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: compositing broken in -next (idr bug)
Message-ID: <20130212215806.GB9057@htj.dyndns.org>
References: <511ABA59.9050604@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511ABA59.9050604@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jiri.

On Tue, Feb 12, 2013 at 10:55:37PM +0100, Jiri Slaby wrote:
> this commit in -next causes my KDE to get stuck while starting. I see
> only the splash screen. If I disable effects by alt-shift-f12, it continues.
> 
> I bisected it to this commit:
> commit 430440fce7da4ad52c2af06a04a5132e5d19faaf
> Author: Tejun Heo <tj@kernel.org>
> Date:   Thu Feb 7 12:31:37 2013 +1100
> 
>     drm: convert to idr_alloc()
> 
> 
> More concretely to the change in drm_gem_flink_ioctl. If I revert solely
> that one, it works again. Maybe I'm blind, but I do not see why...
> 
> Well I see a bug in there, but that is not the root cause -- there is a
> missing call to idr_preload_end. Of course, that one only leaves
> preemption disabled forever.

Fix for this bug is already queued in -mm.

  http://article.gmane.org/gmane.linux.kernel/1439101/raw

But you're saying that adding the missing idr_preload_end() doesn't
make the problem go away, right?

Thanks.

-- 
tejun
