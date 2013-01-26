Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3AZVAJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:00:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3AZVAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:00:07 -0500
Date: Sat, 26 Jan 2013 22:00:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, acme@redhat.com,
        eranian@google.com, jolsa@redhat.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/12] perf, x86: Support the TSX intx/intx_cp qualifiers v2
Message-ID: <20130126210000.GK30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-5-git-send-email-andi@firstfloor.org> <20130126115402.GA13445@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126115402.GA13445@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 12:54:02PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Implement the TSX transaction and checkpointed transaction 
> > qualifiers for Haswell. This allows e.g. to profile the number 
> > of cycles in transactions.
> 
> The changelog should explain why this is a basic feature that is 
> a must-have to have basic perf support. (i.e. default 'perf 
> record', 'perf report', 'perf stat' and 'perf top' works and is 
> meaningful.)

The patch is not needed for primitive cycle sampling only.

These qualifiers are a fundamental feature for any TSX tuning. If you don't
care about TSX it's not fundamental. TSX tuning relies heavily on the PMU,
so for any TSX work it's important. The 0/0 description has more
references on the topic.

It's not easy to use however with just this patch, the "perf stat -T" patch
in the advanced series makes it easy to use.

I will assume the description is sufficient and will not repost with
a new changelog, as "basicness" of the patch is not a useful property
to document in the long term git history.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
