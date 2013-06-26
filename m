Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3FZTKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:10:53 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55763 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3FZTKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:10:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130626103303.GB28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<20130624084338.GI28407@twins.programming.kicks-ass.net>
	<CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
	<20130625104700.GZ28407@twins.programming.kicks-ass.net>
	<20130625105123.GA13649@gmail.com>
	<20130626103303.GB28407@twins.programming.kicks-ass.net>
Date: Wed, 26 Jun 2013 21:10:50 +0200
Message-ID: <CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 12:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 25, 2013 at 12:51:23PM +0200, Ingo Molnar wrote:
>> A syscall (ioctl?) to dump all current vmas into the mmap update stream
>> (to form a starting point) might be handy - that would remove the
>> fragility and overhead of parsing /proc/ details.
>
> Its more difficult than that though :/ Suppose not all mmap events fit
> in the output buffer and you're not able to read from the buffer because
> you're stuck in the ioctl().
>
> This means we need to either force userspace to use threads to reliably
> use the feature; or complicate the ioctl() to allow vma ranges -- which
> introduces an inherent race window etc..
>
> Neither option are really pretty and we already have the maps parse code
> -- also its not _that_ hard to parse either.

After more investigation with the author of the false sharing
detection tool, I think
that if the mapping changes, it is okay. The tool can detect this and
drop the analysis
at that address. So as long as we can flag the mapping change, we are
okay. Hopefully,
it does not occur frequently. If so, then I think there are bigger
issues to fix on the system
than false sharing.
