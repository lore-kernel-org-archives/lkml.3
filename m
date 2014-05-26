Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaEZTxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:53:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48796 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaEZTxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:53:44 -0400
Date: Mon, 26 May 2014 20:53:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/process_vm_access: move into ipc/
Message-ID: <20140526195341.GQ18016@ZenIV.linux.org.uk>
References: <20140524135925.32597.45754.stgit@zurg>
 <alpine.LSU.2.11.1405261210140.3411@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405261210140.3411@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 12:16:20PM -0700, Hugh Dickins wrote:
> On Sat, 24 May 2014, Konstantin Khlebnikov wrote:
> 
> > "CROSS_MEMORY_ATTACH" and mm/process_vm_access.c seems misnamed and misplaced.
> > Actually it's a kind of IPC and it has no more relation to MM than sys_read().
> > This patch moves code into ipc/ and config option into init/Kconfig.
> > 
> > Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> 
> I disagree, and SysV's ipc/ isn't where I would expect to find it.
> How about we just leave it where it is in mm?

Anything playing with get_user_pages(tsk, ...) with tsk != current is very
much a part of VM guts.

While we are at it, do_generic_file_read() *is* in mm/filemap.c.  And signals
and pipes are also "a kind of IPC", so the rationale is really weak.
