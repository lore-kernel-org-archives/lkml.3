Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaIXB7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:59:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40778 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaIXB7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:59:04 -0400
Date: Tue, 23 Sep 2014 21:58:58 -0400 (EDT)
Message-Id: <20140923.215858.1862286673062032624.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: mmarek@suse.cz, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140924072306.799005a3@canb.auug.org.au>
References: <541A28BA.1060201@infradead.org>
	<54218AEF.5090200@suse.cz>
	<20140924072306.799005a3@canb.auug.org.au>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Sep 2014 18:59:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 24 Sep 2014 07:23:06 +1000

> Dave, this is a bit slack of you since I reported that problem a week
> ago in the net tree and yet it has not been completely fixed before you
> asked Linus to pull your tree :-(

There were build failures I saw due to some misbalanced select/depends
issues which I fixed in:

commit df568d8e5250bf24e38c69ad4374baf0f8d279ba
Author: David S. Miller <davem@davemloft.net>
Date:   Mon Sep 22 13:14:33 2014 -0400

    scsi: Use 'depends' with LIBFC instead of 'select'.

which went in yesterday.  I thought that would resolve all of your
problems.

Believe me, it is a tragic surprise that several defconfigs absolutely
depended upon this broken usage of select in the scsi layer, to of all
things make CONFIG_NET=y implicit.

I'll do my best to sort this out, but I hope that this short term pain
is worth it in the end.

Thanks for your understanding.
