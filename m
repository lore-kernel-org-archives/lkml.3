Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaGHVPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:15:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33548 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaGHVPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:15:09 -0400
Date: Wed, 9 Jul 2014 01:15:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] mm: Don't forget to set softdirty on file mapped fault
Message-ID: <20140708211506.GI17860@moon.sw.swsoft.com>
References: <20140708192151.GD17860@moon.sw.swsoft.com>
 <20140708131920.2a857d573e8cc89780c9fa1c@linux-foundation.org>
 <20140708204017.GG17860@moon.sw.swsoft.com>
 <20140708134511.4a32b7400a952541a31e9078@linux-foundation.org>
 <20140708205448.GH17860@moon.sw.swsoft.com>
 <20140708140501.6c293226bfd87e4dff7ef7fb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708140501.6c293226bfd87e4dff7ef7fb@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:05:01PM -0700, Andrew Morton wrote:
> > 
> > In case if page fault happend on dirty filemapping the newly created pte
> > may loose softdirty bit thus if a userspace program is tracking memory
> > changes with help of a memory tracker (CONFIG_MEM_SOFT_DIRTY) it might
> > miss modification of a memory page (which in worts case may lead to
> > data inconsistency).
> 
> Much better, thanks.
> 
> It's a rather gross-looking bug and data inconsistency sounds serious. 
> Do you think a -stable backport is needed?

It seems the memory tracker is not that widespread in userspace
programs (I mean at the moment as far as I know only we use it
intensively) so I don't consider it as critical but moving it
into stable won't hurt. Still I fear in 3.16 the mm/memory.c
code has been significantly reworked so this patch won't apply
on its own. I can prepare a patch for 3.15 though, just say
a word.
