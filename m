Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3GFWyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 18:54:25 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:38383 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3GFWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 18:54:22 -0400
Message-ID: <1373151546.7397.55.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH v3] lib/idr.c rewrite, percpu ida/tag allocator
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        sfr@canb.auug.org.au, andi@firstfloor.org, oleg@redhat.com,
        mingo@redhat.com, axboe@kernel.dk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        target-devel <target-devel@vger.kernel.org>
Date: Sat, 06 Jul 2013 15:59:06 -0700
In-Reply-To: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 22:08 -0700, Kent Overstreet wrote:
> Previous posting: http://thread.gmane.org/gmane.linux.kernel/1511216
> 
> The only real change since the last version is that I've reworked the
> new ida implementation to not use one giant allocation - it's still
> logically one big arary, but it's implemented as an array of arrays.
> 
> With that, it scales up to INT_MAX allocated ids just fine. Benchmarks
> are included in that patch.
> 
> Patch series is available in my git repo:
> git://evilpiepirate.org/~kent/linux-bcache.git idr
> 
> Andrew, want to pick this up for 3.12?

Just FYI that the target-pending/target-per-cpu-ida branch utilizing
per-cpu ida logic for vhost-scsi has been rebased to include this latest
series.  Thanks Kent!

Andrew, what are your plans for this..?

Would you consider allowing this series be merged through target-pending
in order to allow us to start taking advantage of per-cpu ida tag
pre-allocation optimizations for v3.12 target code..? 

Another option would be to merge the per-cpu ida specific piece now for
v3.11 for which the risk is low given it doesn't touch any existing
code, and then include Kent's full idr rewrite separately as v3.12 item.

WDYT..?

--nab

