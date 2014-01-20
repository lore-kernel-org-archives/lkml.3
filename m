Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaATUPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 15:15:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaATUPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 15:15:42 -0500
Date: Mon, 20 Jan 2014 21:15:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCHv2 2/2] Change khugepaged to respect MMF_THP_DISABLE
	flag
Message-ID: <20140120201525.GA31416@redhat.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com> <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com> <20140118234957.GB10970@node.dhcp.inet.fi> <20140120195812.GD18196@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120195812.GD18196@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Alex Thorlton wrote:
>
> No, definitely not.  Upon review, khugepaged_test_exit is the wrong
> place to do this check.  I think I need to move it up to
> khugepaged_scan_mm_slot for this to work correctly.

Why? unless a MMF_THP_DISABLE task does madvise(MADV_HUGEPAGE)
khugepaged_scan_mm_slot() should never see its ->mm ?

Although I got lost a bit, and probably misunderstood... but it
seems to me that whatever you do this patch should not touch
khugepaged_scan_mm_slot.

Oleg.

