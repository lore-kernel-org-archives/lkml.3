Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3BDKsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:48:52 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:52274 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3BDKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:48:51 -0500
Date: Mon, 4 Feb 2013 11:48:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] liblockdep: wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130204104845.GB24173@gmail.com>
References: <1359942644-26371-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359942644-26371-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, these liblockdep bits look really good and clean, and the 
perf integration is obviously useful. It does not conflict with 
any pending tools/perf work either.

Arnaldo, are you fine with:

  b2e7c77a3790 perf: Integrate liblockdep support into perf

?

We could keep it separate in tip:core/locking, no merge into 
tip:perf/core appears to be necessary for the time being.

A couple of suggestions:

1) One thing that is I think is missing is a fun to read 
tools/lib/lockdep/README that explains how to use it all for 
pthread_mutex_t and pthread_rwlock_t checking, and what the 
limitations are (if any).

2) Explicitly mentioning that the code and library is licensed 
under the kernel's GPL would be nice as well, for additional 
clarity - should anyone decide to package it up in distros.

3) Advanced: providing a shell environment variable (LOCKDEP=1?) 
as a way to enable it might be useful as well: that way tools 
could be built with lockdep built in but turned off by default - 
which can be turned on again on demand. It would only constitute 
some data structure overhead, a runtime check in the locking 
wrappers and a bit of an initialization overhead.

Thanks,

	Ingo
