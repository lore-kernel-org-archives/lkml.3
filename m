Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaLNOVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:21:20 -0500
Received: from mail2.tiolive.com ([94.23.229.207]:45790 "EHLO
	mail2.tiolive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaLNOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:21:19 -0500
Date: Sun, 14 Dec 2014 17:21:48 +0300
From: Kirill Smelkov <kirr@nexedi.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/liblockdep: Fix debug_check thinko in mutex destroy
Message-ID: <20141214142148.GA2679@teco.navytux.spb.ru>
References: <1418036879-31944-1-git-send-email-kirr@nexedi.com>
 <5485BCEA.30207@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5485BCEA.30207@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 09:59:54AM -0500, Sasha Levin wrote:
> On 12/08/2014 06:07 AM, Kirill Smelkov wrote:
> > In mutex destroy code currently we pass to debug_check_no_locks_freed()
> > 
> >     [mem_from, mem_end)
> > 
> > address region. But debug_check_no_locks_freed() accepts
> > 
> >     mem_from, mem_*len*
> > 
> > i.e. second parameter is region length, not end address. And it was
> > always so, starting from 2006 (fbb9ce95 "lockdep: core").
> > 
> > Fix it, or else on a mutex destroy we wrongly check
> > much-wider-than-mutex region and can find not-yet-released other locks
> > there and wrongly report BUGs on them.
> 
> Great catch, thanks!

Thanks, where is this patch is/will-be applied?

I mean I could not find it neither in

    git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux.git

nor anywhere in linux-next nor in Linus's tree.

Thanks,
Kirill
