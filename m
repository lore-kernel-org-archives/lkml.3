Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3GOKf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:35:26 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:42541 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3GOKfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:35:24 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <CAPB2xN89n=1JLQe7w_+J8A246HsUDv0oP1WCjQ=4OFJnDDGchQ@mail.gmail.com>
References: <20130705155113.3586.78292.stgit@maximpc.sw.ru>
	<20130711185104.GC5349@quack.suse.cz>
	<CAPB2xN89n=1JLQe7w_+J8A246HsUDv0oP1WCjQ=4OFJnDDGchQ@mail.gmail.com>
Date: Mon, 15 Jul 2013 12:35:23 +0200
Message-ID: <CAJfpegtNRxacv3Lw0XOK7zuQJB0_NttNzw7p3fQE+J7T_dZHyQ@mail.gmail.com>
Subject: Re: [PATCH] mm: strictlimit feature -v3
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        riel@redhat.com, Kirill Korotaev <dev@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>, linux-mm@kvack.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, fengguang.wu@intel.com,
        devel@openvz.org, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 11:50 PM, Maxim Patlasov
<MPatlasov@parallels.com> wrote:
> On Thu, Jul 11, 2013 at 10:51 PM, Jan Kara <jack@suse.cz> wrote:

[snipped]

>> If I'm right in the above, then removing NR_WRITEBACK_TEMP would be a nice
>> followup patch.
>
> I'd rather introduce the notion of trusted fuse filesystem. If system
> administrator believe given fuse fs "trusted", it works w/o
> strictlimit, but fuse daemon is supposed to notify the kernel
> explicitly about threads related to processing writeback. The kernel
> would raise a per-task flag for those threads. And, calculating
> nr_dirty in balance_dirty_pages, we'd add NR_WRITEBACK_TEMP for all,
> excepting tasks with the flag set.  This is very simple and will work
> perfectly.

Yes, doing a trusted mode for fuse is a good idea, I think.  And it
should have a new filesystem type (can't think of a good name though,
"fusetrusted" is a bit too long).

Thanks,
Miklos
