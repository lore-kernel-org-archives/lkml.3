Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847Ab3FUM6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:58:14 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:41570 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756683Ab3FUM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:58:13 -0400
Message-ID: <51C44DE3.3000202@newflow.co.uk>
Date: Fri, 21 Jun 2013 13:58:11 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.0-rc4: jffs2: Possible circular locking dependency detected
References: <51C2FC56.1070808@newflow.co.uk>
In-Reply-To: <51C2FC56.1070808@newflow.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/13 13:57, Mark Jackson wrote:
> Just mounted a JFFS2 partition (held in NOR flash on a custom AM335x
> CPU board), and I always get the following:-
> 
> [    3.864244]
> [    3.865851] ======================================================
> [    3.872359] [ INFO: possible circular locking dependency detected ]
> [    3.878968] 3.10.0-rc4-00172-gf31c62e-dirty #249 Not tainted
> [    3.884926] -------------------------------------------------------
> [    3.891526] rcS/507 is trying to acquire lock:
> [    3.896206]  (&mm->mmap_sem){++++++}, at: [<c00b42c8>] might_fault+0x3c/0x94
> [    3.903684]
> [    3.903684] but task is already holding lock:
> [    3.909826]  (&f->sem){+.+.+.}, at: [<c016f208>] jffs2_readdir+0x40/0x1b0
> [    3.917021]
> [    3.917021] which lock already depends on the new lock.

Looks like I reported something similar earlier this year:-

http://lists.infradead.org/pipermail/linux-mtd/2013-February/045888.html

And I also found this going back to 3.0.18:-

http://www.spinics.net/lists/linux-rt-users/msg07617.html


