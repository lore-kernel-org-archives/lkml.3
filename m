Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3GHCEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:04:37 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:50440 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3GHCEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:04:36 -0400
Message-ID: <1373249375.7397.139.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH v3] lib/idr.c rewrite, percpu ida/tag allocator
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, tj@kernel.org, sfr@canb.auug.org.au,
        andi@firstfloor.org, oleg@redhat.com, mingo@redhat.com,
        axboe@kernel.dk, target-devel <target-devel@vger.kernel.org>
Date: Sun, 07 Jul 2013 19:09:35 -0700
In-Reply-To: <20130707114852.GA5463@redhat.com>
References: <1373087301-23730-1-git-send-email-kmo@daterainc.com>
	 <1373151546.7397.55.camel@haakon3.risingtidesystems.com>
	 <20130707114852.GA5463@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-07 at 14:48 +0300, Michael S. Tsirkin wrote:
> On Sat, Jul 06, 2013 at 03:59:06PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2013-07-05 at 22:08 -0700, Kent Overstreet wrote:
> > > Previous posting: http://thread.gmane.org/gmane.linux.kernel/1511216
> > > 
> > > The only real change since the last version is that I've reworked the
> > > new ida implementation to not use one giant allocation - it's still
> > > logically one big arary, but it's implemented as an array of arrays.
> > > 
> > > With that, it scales up to INT_MAX allocated ids just fine. Benchmarks
> > > are included in that patch.
> > > 
> > > Patch series is available in my git repo:
> > > git://evilpiepirate.org/~kent/linux-bcache.git idr
> > > 
> > > Andrew, want to pick this up for 3.12?
> > 
> > Just FYI that the target-pending/target-per-cpu-ida branch utilizing
> > per-cpu ida logic for vhost-scsi has been rebased to include this latest
> > series.  Thanks Kent!
> > 
> > Andrew, what are your plans for this..?
> > 
> > Would you consider allowing this series be merged through target-pending
> > in order to allow us to start taking advantage of per-cpu ida tag
> > pre-allocation optimizations for v3.12 target code..? 
> > 
> > Another option would be to merge the per-cpu ida specific piece now for
> > v3.11 for which the risk is low given it doesn't touch any existing
> > code, and then include Kent's full idr rewrite separately as v3.12 item.
> > 
> > WDYT..?
> 
> Takes as is, this conflicts with cleanup patches by Asias in vhost-next
> that I was going to send to Linus for 3.11.

So the proposed vhost-scsi per-cpu ida/tag pre-allocation changes should
be considered v3.12 items.

> Merging new target code for 3.11 and vhost code for 3.12
> helps keep the dependencies simple, so I'm all for it.
> 

My point above is that having (at least) Kent's per-cpu ida code merged
for v3.11 would make it easier to move forward during the v3.12 cycle on
per-cpu ida/tag conversions for vhost-scsi + other target fabric
drivers.

--nab

