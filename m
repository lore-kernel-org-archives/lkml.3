Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaFDKed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaFDKec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:34:32 -0400
Date: Wed, 4 Jun 2014 12:35:45 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: blk-mq: bitmap tag: performance degradation?
Message-ID: <20140604103544.GA11350@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens, et al

With new bitmap tags I am observing performance degradation on 'null_blk'
device with 512 queue depth. This is 'fio' config used:

[global]
bs=4k
size=16g

[nullb]
filename=/dev/nullb0
direct=1
rw=randread
numjobs=8


I tried machines with 16 and 48 CPUs and it seems the more
CPUs we have the worse the result. Here is 48 CPUs one:

3.15.0-rc4+

   READ: io=131072MB, aggrb=3128.7MB/s, minb=400391KB/s, maxb=407204KB/s,
mint=41201msec, maxt=41902msec

   548,549,235,428 cycles:k
     3,759,335,303 L1-dcache-load-misses
       419,021,008 cache-misses:k                                              

      39.659121371 seconds time elapsed

3.15.0-rc1.for-3.16-blk-mq-tagging+

   READ: io=131072MB, aggrb=1951.8MB/s, minb=249824KB/s, maxb=255851KB/s,
mint=65574msec, maxt=67156msec

 1,063,669,976,651 cycles:k
     4,572,746,591 L1-dcache-load-misses
     1,127,037,813 cache-misses:k                                              

      69.446112553 seconds time elapsed

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
