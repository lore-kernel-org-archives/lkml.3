Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3GHUQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:16:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHUQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:16:29 -0400
Date: Mon, 8 Jul 2013 13:16:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        tj@kernel.org, sfr@canb.auug.org.au, andi@firstfloor.org,
        oleg@redhat.com, mingo@redhat.com, axboe@kernel.dk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH v3] lib/idr.c rewrite, percpu ida/tag allocator
Message-Id: <20130708131627.02af52fbf809ed44dc044b89@linux-foundation.org>
In-Reply-To: <1373151546.7397.55.camel@haakon3.risingtidesystems.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
	<1373151546.7397.55.camel@haakon3.risingtidesystems.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Jul 2013 15:59:06 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Fri, 2013-07-05 at 22:08 -0700, Kent Overstreet wrote:
> > Previous posting: http://thread.gmane.org/gmane.linux.kernel/1511216
> > 
> > The only real change since the last version is that I've reworked the
> > new ida implementation to not use one giant allocation - it's still
> > logically one big arary, but it's implemented as an array of arrays.
> > 
> > With that, it scales up to INT_MAX allocated ids just fine. Benchmarks
> > are included in that patch.
> > 
> > Patch series is available in my git repo:
> > git://evilpiepirate.org/~kent/linux-bcache.git idr
> > 
> > Andrew, want to pick this up for 3.12?
> 
> Just FYI that the target-pending/target-per-cpu-ida branch utilizing
> per-cpu ida logic for vhost-scsi has been rebased to include this latest
> series.  Thanks Kent!
> 
> Andrew, what are your plans for this..?

Firstly, to review it.  It's a lot of code so I'll be doing this after
-rc1 is released.

Meanwhile, we probably need a resend - all the patches hit my inbox
directly, but quite a lot of them failed to come through on
linux-kernel - it appears that the patches which had huuuuuge Cc lists
were suppressed.
