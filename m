Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaHVUiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:38:14 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:43970 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaHVUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:38:12 -0400
Date: Sat, 23 Aug 2014 00:38:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v3
Message-ID: <20140822203809.GC25918@moon>
References: <20140804172255.109539743@openvz.org>
 <20140804172610.965949916@openvz.org>
 <20140821155115.8433bb37bf631b8ae8340f84@linux-foundation.org>
 <20140822063242.GI14072@moon>
 <20140821234912.f007e2fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821234912.f007e2fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:49:12PM -0700, Andrew Morton wrote:
> > > 
> > > But it's a bit hacky.  Can anyone think of anything smarter?
> > 
> > Looks good to me and not that hacky actually.
> 
> Hacky :( I guess it's pretty safe because this is a userspace-visible
> structure so we'll never be changing it.

Well, I saw something similar in netfilter code a long ago :)

> 
> Or will we?  What happens if we later decide that some additional field
> needs to be added?  Do we version the interface?  Add a new prctl()
> mode?  Let's cook up a plan for that and at least add to changelog?

I don't expect to change it anytime soon but we still have an option --
if we decide to extend or shrink it we always can use sizeof/offsetof
helpers to check which exactly version userspace asks us to use.
As far as I understand the mm_struct is not the structure which
changes that frequently, right?

> > Should I update on top for -mm tree?
> 
> Spose so.  Let's see what the code savings are when the other two sites
> are similarly changed?
> 
> To save a bit more space offsets[] could be an array of uchar, I guess.
> A BUILD_BUG_ON(sizeof(struct prctl_map) >= 256) would keep that sane.

Sure, thanks!
