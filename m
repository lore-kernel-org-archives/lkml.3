Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762496Ab3IDMdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:33:55 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49315 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab3IDMdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:33:53 -0400
Date: Wed, 4 Sep 2013 14:33:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] sched/cputime: do not scale when utime == 0
Message-ID: <20130904123350.GA9773@gmail.com>
References: <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
 <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
 <20130902135033.GA1686@redhat.com>
 <20130902140015.GB2368@swordfish.minsk.epam.com>
 <20130903084306.GA2694@redhat.com>
 <20130903180912.GA2340@swordfish>
 <20130903183229.GB30757@gmail.com>
 <20130904120857.GB2564@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904120857.GB2564@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> scale_stime() silently assumes that stime < rtime, otherwise when
> stime == rtime and both values are big (operations on them do not fit
> in 32 bits), the resulting scaling stime can be bigger than rtime.
> In consequence utime = rtime - stime results in negative value.

Please also describe observed/expected symptoms of this bug in apps, so 
that we can later on redirect bugreporters to this fix and filter out new 
symptoms (if any).

Thanks,

	Ingo
