Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaFBRdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:33:37 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:45885 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaFBRdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:33:36 -0400
Date: Mon, 2 Jun 2014 13:33:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paolo Valente <paolo.valente@unimore.it>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140602173332.GB8912@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it>
 <20140530232804.GA5057@htj.dyndns.org>
 <20140602111432.GA3737@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602111432.GA3737@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

On Mon, Jun 02, 2014 at 01:14:33PM +0200, Pavel Machek wrote:
> Now.. I see it is more work for storage maintainers, because there'll
> be more code to maintain in the interim. But perhaps user advantages
> are worth it?

I'm quite skeptical about going that route.  Not necessarily because
of the extra amount of work but more the higher probability of getting
into situation where we can neither push forward or back out.  It's
difficult to define clear deadline and there will likely be unforeseen
challenges in the planned convergence of the two schedulers,
eventually, it isn't too unlikely to be in a situation where we have
to admit defeat and just keep both schedulers.  Note that developer
overhead isn't the only factor here.  Providing two slightly different
alternatives inevitably makes userland grow dependencies on subtleties
of both and there's a lot less pressure to make judgement calls and
take appropriate trade-offs, which have fairly high chance of
deadlocking progress towards any direction.

Thanks.

-- 
tejun
