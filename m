Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541Ab3BTQrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:47:05 -0500
Received: from server506f.appriver.com ([50.56.144.36]:55785 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934044Ab3BTQrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:47:01 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2013 11:47:01 EST
X-Note-AR-ScanTimeLocal: 2/20/2013 10:42:00 AM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Kent Overstreet <koverstreet@google.com>
CC: "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<axboe@kernel.dk>" <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>,
        "Jiri Kosina" <jkosina@suse.cz>, Jim Paris <jim@jtan.com>,
        Geoff Levand <geoff@infradead.org>, Alasdair Kergon <agk@redhat.com>,
        "<dm-devel@redhat.com>" <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 09/27] block: Use bio_sectors() more consistently
Thread-Topic: [PATCH 09/27] block: Use bio_sectors() more consistently
Thread-Index: AQHODwByeH1L7hViWEKnA2dG6lUK8piDWPcA
Date: Wed, 20 Feb 2013 16:43:34 +0000
Message-ID: <DFE3B626E00A3346A98511AD95B78358065785@DAGN05A-E6.exg6.exghost.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
 <1361319761-23873-10-git-send-email-koverstreet@google.com>
In-Reply-To: <1361319761-23873-10-git-send-email-koverstreet@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [72.32.31.161]
x-rerouted-by-exchange: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F6B8818A28CAA4BB4EEEEA2E244E335@exg6.exghost.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That looks OK to me.

(I notice that while back in October it included changes to aoe, the current patch does not, which is fine.)

On Feb 19, 2013, at 7:22 PM, Kent Overstreet wrote:

> Bunch of places in the code weren't using it where they could be -
> this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
> into a struct bvec_iter.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: "Ed L. Cashin" <ecashin@coraid.com>
> CC: Nick Piggin <npiggin@kernel.dk>
> CC: Jiri Kosina <jkosina@suse.cz>
> CC: Jim Paris <jim@jtan.com>
> CC: Geoff Levand <geoff@infradead.org>
> CC: Alasdair Kergon <agk@redhat.com>
> CC: dm-devel@redhat.com
> CC: Neil Brown <neilb@suse.de>
> CC: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Ed Cashin <ecashin@coraid.com>
> ---
> drivers/block/pktcdvd.c      |  2 +-
> drivers/md/dm-raid1.c        |  2 +-
> drivers/md/raid0.c           |  6 +++---
> drivers/md/raid1.c           | 17 ++++++++---------
> drivers/md/raid10.c          | 24 +++++++++++-------------
> drivers/md/raid5.c           |  8 ++++----
> fs/btrfs/volumes.c           |  2 +-
> include/trace/events/block.h | 12 ++++++------
> 8 files changed, 35 insertions(+), 38 deletions(-)
...

-- 
  Ed Cashin
  ecashin@coraid.com


