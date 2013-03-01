Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab3CAVfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:35:17 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:36479 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3CAVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:35:16 -0500
Date: Fri, 1 Mar 2013 13:35:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: markus@trippelsdorf.de, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
Message-ID: <20130301213511.GF2481@mtj.dyndns.org>
References: <20130228090846.GA249@x4>
 <20130301133159.0711f81a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301133159.0711f81a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Fri, Mar 01, 2013 at 01:31:59PM -0800, Andrew Morton wrote:
> okluar passed a negative `wd' into inotify_rm_watch()?
> 
> I wonder why it did that.  I doubt if inotify_add_watch() ever returns
> negative descriptors, in which case I expect that okular's call to
> inotify_add_watch() returned -1 and an errno and okular forgot to check
> it, and later passed that -1 back into inotify_rm_watch().
> 
> Anyway, I guess we need to make inotify_add_watch() refuse to return
> negative descriptors (presumably this is already the case due to idr
> internals) and make inotify_rm_watch() trap negative values of `wd' up
> front.
> 
> I wonder how many other such gremlins the IDR checking has added.

The WARN_ON() is just for cases where someone might be doing something
crazy with the previous behavior of ignoring high bit.  Maybe I was
being overly paranoid and we should just drop it from idr_find().

Thanks.

-- 
tejun
