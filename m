Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab3JOSZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:25:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab3JOSZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:25:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: blk_mq_update_queue_map makes an (invalid?) assumption about cpu ordering
References: <x49fvs2pgjx.fsf@segfault.boston.devel.redhat.com>
	<20131015181403.GY541@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 15 Oct 2013 14:25:00 -0400
In-Reply-To: <20131015181403.GY541@kernel.dk> (Jens Axboe's message of "Tue,
	15 Oct 2013 12:14:03 -0600")
Message-ID: <x491u3mpf2b.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> This assumes that the first_sibling is listed before any other siblings,
>> which I don't believe is true.  I don't think you get any guaranteed
>> ordering in that cpu_possible_mask.
>> 
>> ... or did I miss something?
>
> That's correct, it's assuming the first sibling is the lowest numbered
> one. Are there cases where that would not be correct? I was sort of
> assuming that was what "first" meant here.

Yeah, you're right.  I hadn't read down the call chain:

static int get_first_sibling(unsigned int cpu)
        ret = cpumask_first(topology_thread_cpumask(cpu));

Nothing to see here, move along...

-Jeff
