Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaE0PIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:08:45 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43003 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaE0PIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:08:44 -0400
Message-ID: <5384AA79.4010206@kernel.dk>
Date: Tue, 27 May 2014 09:08:41 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>, Kent Overstreet <kmo@daterainc.com>
CC: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 09:03, Mikulas Patocka wrote:
> The block layer uses per-process bio list to avoid recursion in
> generic_make_request. When generic_make_request is called recursively, the
> bio is added to current->bio_list and the function returns immediatelly.
> The top-level instance of generic_make_requests takes bios from
> current->bio_list and processes them.

This really begs the question of why we just don't use the per-process 
plugs for this. We already have scheduler hooks in place to flush those 
at the appropriate time. Why are we reinventing something for 
essentially the same thing?

-- 
Jens Axboe

