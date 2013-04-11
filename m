Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161541Ab3DKPUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:20:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42639 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935788Ab3DKPUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:20:25 -0400
Message-ID: <5166D498.2090808@zytor.com>
Date: Thu, 11 Apr 2013 08:19:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] cputime: remove scaling
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com> <1364489605-5443-5-git-send-email-sgruszka@redhat.com> <20130410120228.GC8083@gmail.com> <11f12774-5353-4380-82d0-e22707e11729@email.android.com> <20130411083734.GC1380@redhat.com>
In-Reply-To: <20130411083734.GC1380@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 01:37 AM, Stanislaw Gruszka wrote:
> On Wed, Apr 10, 2013 at 07:29:21AM -0700, H. Peter Anvin wrote:
>> I have a patch that does scaling by multiply for 64-bit architectures.  I probably should clean it up and send it in.  I need to see if it fixes this problem.
> Interesting. Could you attach draft patch, so I could look at it ?
> 

It's just the trivial extension of the code already in kernel/time.c to
the 64-bit case.

However, it looks like in your case the scaling factor stime/total is
dynamic.  This means that doing scaling by multiplication isn't practical.

I guess I don't understand what function the scaling is supposed to
serve there.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

