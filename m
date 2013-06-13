Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3FMBq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:46:57 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:43958 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3FMBqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:46:55 -0400
Message-ID: <1371088013.1746.80.camel@buesod1.americas.hpqcorp.net>
Subject: Re: next-20130607 BUG: sleeping function called from invalid
 context at lib/idr.c:424
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 18:46:53 -0700
In-Reply-To: <4972.1371086526@turing-police.cc.vt.edu>
References: <19828.1370975638@turing-police.cc.vt.edu>
	 <1370975900.1744.20.camel@buesod1.americas.hpqcorp.net>
	 <4972.1371086526@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 21:22 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 11 Jun 2013 11:38:20 -0700, Davidlohr Bueso said:
> 
> > > Looking at 'git blame', I see a bunch of patches from Davidlohr Bueso on 06/07
> > > that hit ipc/util.c and friends.
> >
> > Yeah, this is my fault. It was originally reported by Fengguang:
> > http://www.spinics.net/lists/kernel/msg1545633.html#.UbYI9qqdmV8
> >
> > Sasha proposed a fix to use GFP_ATOMIC in idr_preload instead of
> > GFP_KERNEL:
> >
> > http://lkml.org/lkml/2013/6/10/322
> 
> Confirming that Sasha's proposed fix eliminates the BUG in my kernel,
> so if GFP_ATOMIC is acceptable otherwise, feel free to stick a Tested-By:
> on it of you like.

Actually, this is the fix we are going with:
https://lkml.org/lkml/2013/6/11/705

Thanks,
Davidlohr



