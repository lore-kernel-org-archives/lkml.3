Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3GGLsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 07:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab3GGLsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 07:48:10 -0400
Date: Sun, 7 Jul 2013 14:48:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Kent Overstreet <kmo@daterainc.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, sfr@canb.auug.org.au,
        andi@firstfloor.org, oleg@redhat.com, mingo@redhat.com,
        axboe@kernel.dk, target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH v3] lib/idr.c rewrite, percpu ida/tag allocator
Message-ID: <20130707114852.GA5463@redhat.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
 <1373151546.7397.55.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373151546.7397.55.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 03:59:06PM -0700, Nicholas A. Bellinger wrote:
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
> 
> Would you consider allowing this series be merged through target-pending
> in order to allow us to start taking advantage of per-cpu ida tag
> pre-allocation optimizations for v3.12 target code..? 
> 
> Another option would be to merge the per-cpu ida specific piece now for
> v3.11 for which the risk is low given it doesn't touch any existing
> code, and then include Kent's full idr rewrite separately as v3.12 item.
> 
> WDYT..?

Takes as is, this conflicts with cleanup patches by Asias in vhost-next
that I was going to send to Linus for 3.11.
Merging new target code for 3.11 and vhost code for 3.12
helps keep the dependencies simple, so I'm all for it.


> 
> --nab
