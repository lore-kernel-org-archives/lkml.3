Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935893Ab3DITOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:14:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935459Ab3DITOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:14:10 -0400
Date: Tue, 9 Apr 2013 15:13:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
Message-ID: <20130409191339.GP6320@redhat.com>
References: <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <20130409184248.GO6320@redhat.com>
 <20130409185721.GF6186@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409185721.GF6186@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:57:21AM -0700, Tejun Heo wrote:

[..]
> And destroy all per-ioc and cgroup logics in block layer in the
> process.

Oh, I am in no-way suggesting don't use bio_associate_current(). I am 
just trying to analyze the performance issue right now and saying that
as far as performance is concenred, one will get it back even if one
does not use bio_associate_current().

Yes but one needs to use bio_associate_current() to make sure bio's
are attributed to right cgroup and associate bio to right task. This
should help solving the long standing issue of task losing its ioprio
if dm-crypt target is in the stack.

Thanks
Vivek
