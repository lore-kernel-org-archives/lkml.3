Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3FKSiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:38:23 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:12675 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3FKSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:38:22 -0400
Message-ID: <1370975900.1744.20.camel@buesod1.americas.hpqcorp.net>
Subject: Re: next-20130607 BUG: sleeping function called from invalid
 context at lib/idr.c:424
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Tue, 11 Jun 2013 11:38:20 -0700
In-Reply-To: <19828.1370975638@turing-police.cc.vt.edu>
References: <19828.1370975638@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 14:33 -0400, Valdis Kletnieks wrote:
> Tried to boot next-20130607, got this during early boot.  -0603 is OK, so
> whatever did it is a recent patch. Not sure who's fault it is, as idr_preload()
> has been there since February, apparently something in the SyS_semget()
> path has been changed...
> 
> Looking at 'git blame', I see a bunch of patches from Davidlohr Bueso on 06/07
> that hit ipc/util.c and friends.

Yeah, this is my fault. It was originally reported by Fengguang:
http://www.spinics.net/lists/kernel/msg1545633.html#.UbYI9qqdmV8

Sasha proposed a fix to use GFP_ATOMIC in idr_preload instead of
GFP_KERNEL:

http://lkml.org/lkml/2013/6/10/322

Thanks,
Davidlohr


