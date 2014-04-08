Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaDHRBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:01:42 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:40244 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaDHRBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140408164652.GL7292@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
	<53440A5D.6050301@zytor.com>
	<CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
	<20140408164652.GL7292@suse.de>
Date: Tue, 8 Apr 2014 10:01:39 -0700
X-Google-Sender-Auth: trLmbbfDmz2IaSrJK_j_dap6uow
Message-ID: <CA+55aFwrwYmWFXWpPeg-keKukW0=dwvmUBuN4NKA=JcseiUX3g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 9:46 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> If you are ok with leaving _PAGE_NUMA as _PAGE_PROTNONE

NO I AM NOT!

Dammit, this feature is f*cking brain-damaged.

My complaint has been (and continues to be):

 - either it is 100% the same as PROTNONE, in which case thjat
_PAGE_NUMA bit had better go away, and you just use the protnone
helpers!

 - if it's not the same as PROTNONE, then it damn well needs a different bit.

You can't have it both ways. You guys tried. The Xen case shows that
trying to distinguish the two DOES NOT WORK. But even apart from the
Xen case, it was just a confusing hell.

Like Yoda said: "Either they are the same or they are not. There is no 'try'".

So pick one solution. Don't try to pick the mixed-up half-way case
that is a disaster and makes no sense.

                  Linus
