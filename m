Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3FZPT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:19:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60493 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3FZPT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:19:56 -0400
Date: Wed, 26 Jun 2013 12:33:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130626103303.GB28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <20130624084338.GI28407@twins.programming.kicks-ass.net>
 <CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
 <20130625104700.GZ28407@twins.programming.kicks-ass.net>
 <20130625105123.GA13649@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625105123.GA13649@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:51:23PM +0200, Ingo Molnar wrote:
> A syscall (ioctl?) to dump all current vmas into the mmap update stream 
> (to form a starting point) might be handy - that would remove the 
> fragility and overhead of parsing /proc/ details.

Its more difficult than that though :/ Suppose not all mmap events fit
in the output buffer and you're not able to read from the buffer because
you're stuck in the ioctl().

This means we need to either force userspace to use threads to reliably
use the feature; or complicate the ioctl() to allow vma ranges -- which
introduces an inherent race window etc..

Neither option are really pretty and we already have the maps parse code
-- also its not _that_ hard to parse either.
