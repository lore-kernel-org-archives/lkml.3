Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbaDJAM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:12:26 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:49537 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbaDJAMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:12:24 -0400
MIME-Version: 1.0
In-Reply-To: <5345D912.7000606@zytor.com>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
	<53440A5D.6050301@zytor.com>
	<CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
	<20140408164652.GL7292@suse.de>
	<20140408173031.GS10526@twins.programming.kicks-ass.net>
	<20140409062103.GA7294@gmail.com>
	<5345D912.7000606@zytor.com>
Date: Wed, 9 Apr 2014 17:12:24 -0700
X-Google-Sender-Auth: YUaXQXzbgunuaw0ui2mLHzK9H5o
Message-ID: <CA+55aFwMVjsYpT+c0GukgU18_YEKKWtXVpOk0ePRAtCDU71jqA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 4:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> How painful would it be to get rid of _PAGE_NUMA entirely?  Page bits
> are a highly precious commodity and saving one would be valuable.

I don't think _PAGE_NUMA is a problem. It's only set when the page is
not present, so we have tons of bits then.

Now, that's still inconvenient for the 32-bit pte case, because we do
*not* have tons of bits for non-present cases since we need them for
the swap indexes.

This is different from _PAGE_SOFT_DIRTY, which we do need for both
present and swapped-out entries.

Or am I missing something?

            Linus
