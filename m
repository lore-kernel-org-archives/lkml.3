Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3KAPnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:43:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab3KAPnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:43:42 -0400
Date: Fri, 1 Nov 2013 11:43:39 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
Subject: stec skd block driver needs updating for immutable biovec
Message-ID: <20131101154338.GA23501@redhat.com>
References: <20131101135931.GA22903@redhat.com>
 <5273C2B8.5030608@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5273C2B8.5030608@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens and Kent,

You're likely already aware of this but building the latest
linux-block.git 'for-next' I get:

  CC [M]  drivers/block/skd_main.o
drivers/block/skd_main.c: In function ‘skd_request_fn’:
drivers/block/skd_main.c:773: error: ‘struct bio’ has no member named ‘bi_sector’
drivers/block/skd_main.c: In function ‘skd_end_request_bio’:
drivers/block/skd_main.c:1142: error: ‘struct bio’ has no member named ‘bi_sector’
drivers/block/skd_main.c: In function ‘skd_preop_sg_list_bio’:
drivers/block/skd_main.c:1198: error: implicit declaration of function ‘bio_iovec_idx’
drivers/block/skd_main.c:1198: warning: assignment makes pointer from integer without a cast
drivers/block/skd_main.c: In function ‘skd_log_skreq’:
drivers/block/skd_main.c:5814: error: ‘struct bio’ has no member named ‘bi_sector’
make[2]: *** [drivers/block/skd_main.o] Error 1
make[1]: *** [drivers/block] Error 2
make: *** [drivers] Error 2

All the bi_sector ones are low hanging fruit, but the conversion for
skd_preop_sg_list_bio()'s bio_vec code is more involved.

Kent, any chance you could crank through it?

If not I can come back to trying to fix this later.. but I'm working
through a test merge of linux-dm.git's 'for-next' with linux-block.git's
'for-next'.

(I happen to have one of these stec cards so I'll be able to test)

Mike
