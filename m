Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab3BSH6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:58:30 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59674 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3BSH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:58:29 -0500
Date: Tue, 19 Feb 2013 08:58:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: peterz@infradead.org, jamie.iles@oracle.com, penberg@kernel.org,
        acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [liblockdep] Re: [PATCH v2 01/11] liblockdep: remove the need for
 liblockdep_init
Message-ID: <20130219075825.GA3741@gmail.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> Use a constructor in the library instead of making the user manually
> call liblockdep_init().
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  tools/lib/lockdep/common.c                    | 2 +-
>  tools/lib/lockdep/include/liblockdep/common.h | 1 -
>  tools/lib/lockdep/tests/AA.c                  | 1 -
>  tools/lib/lockdep/tests/ABBA.c                | 1 -
>  tools/lib/lockdep/tests/ABBCCA.c              | 1 -
>  tools/lib/lockdep/tests/ABBCCDDA.c            | 1 -
>  tools/lib/lockdep/tests/ABCABC.c              | 1 -
>  tools/lib/lockdep/tests/ABCDBCDA.c            | 1 -
>  tools/lib/lockdep/tests/ABCDBDDA.c            | 1 -
>  tools/lib/lockdep/tests/WW.c                  | 1 -
>  tools/lib/lockdep/tests/unlock_balance.c      | 1 -
>  tools/lib/lockdep/uinclude/linux/lockdep.h    | 1 -
>  12 files changed, 1 insertion(+), 12 deletions(-)

Note that due to the heavy objections in the kvmtool thread I 
have removed the tools/lib/lockdep library and tooling commits 
from the locking tree - to be able to merge the other locking 
commits upstream.

I'm pretty sad about this outcome as your code really brought 
new development life into lockdep - if you still want to pursue 
this approach then you might want to try it via the tools/kvm 
tree, or via a separate project.

Thanks,

	Ingo
