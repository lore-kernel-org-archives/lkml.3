Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3BTVzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:55:43 -0500
Received: from two.firstfloor.org ([193.170.194.197]:60985 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3BTVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:55:42 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2013 16:55:42 EST
Date: Wed, 20 Feb 2013 22:48:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf x86: Change SandyBridge and IvyBrige instructions
 event to be precise
Message-ID: <20130220214816.GC2928@two.firstfloor.org>
References: <1361392794-16552-1-git-send-email-jolsa@redhat.com>
 <m2ppzuyaao.fsf@firstfloor.org>
 <CABPqkBTCJF9eF_3Nj9nV=PNqVnrcZhkZ90oJfQ6tpHzFDFgptg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTCJF9eF_3Nj9nV=PNqVnrcZhkZ90oJfQ6tpHzFDFgptg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think it buys you much. People read too much into what
> PEBS gives you. I can show you examples where PEBS
> is worse than no PEBS.

Nothing is perfect in sampling, but the precise instructions event
is definitely better in a range of situations. It avoids
a lot of shadow effects.

I think it's a good choice for a lot of situations, although
on Ivy Bridge without EventingRip the BB walking is still
fairly expensive.

It would be a good default for the "user only asks for instructions
for sampling and nothing else" situation, especially on Haswell
which has EventingRip. But that's not straight forward to detect.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
