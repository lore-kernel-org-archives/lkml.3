Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaAQUe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:34:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbaAQUey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:34:54 -0500
Date: Fri, 17 Jan 2014 21:34:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20140117203444.GA16396@redhat.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com> <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Alex Thorlton wrote:
>
>  static inline int khugepaged_test_exit(struct mm_struct *mm)
>  {
> -	return atomic_read(&mm->mm_users) == 0;
> +	return atomic_read(&mm->mm_users) == 0 ||
> +	       (mm->flags & MMF_THP_DISABLE_MASK);
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

test_bit(MMF_THP_DISABLE) ?

And I am not sure this and another check in transparent_hugepage_enabled
is actually right...

I think that MMF_THP_DISABLE_MASK should not disable thp if this
vma has VM_HUGEPAGE set, iow perhaps madvise() should work even
after PR_SET_THP_DISABLE?

IOW, MMF_THP_DISABLE should act as khugepaged_req_madv().

But again, I won't argue.

Oleg.

