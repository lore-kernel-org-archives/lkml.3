Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaALN4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 08:56:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaALN4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 08:56:11 -0500
Date: Sun, 12 Jan 2014 14:56:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: thp: Add per-mm_struct flag to control THP
Message-ID: <20140112135600.GA15051@redhat.com>
References: <1389383718-46031-1-git-send-email-athorlton@sgi.com> <20140111155337.GA16003@redhat.com> <20140111193003.GA10649@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111193003.GA10649@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, Alex Thorlton wrote:
>
> On Sat, Jan 11, 2014 at 04:53:37PM +0100, Oleg Nesterov wrote:
>
> > I simply can't understand, this all looks like overkill. Can't you simply add
> >
> > 	#idfef CONFIG_TRANSPARENT_HUGEPAGE
> > 	case GET:
> > 		error = test_bit(MMF_THP_DISABLE);
> > 		break;
> > 	case PUT:
> > 		if (arg2)
> > 			set_bit();
> > 		else
> > 			clear_bit();
> > 		break;
> > 	#endif
> >
> > into sys_prctl() ?	
>
> That's probably a better solution.  I wasn't sure whether or not it was
> better to have two functions to handle this, or to have one function
> handle both.  If you think it's better to just handle both with one,
> that's easy enough to change.

Personally I think sys_prctl() can handle this itself, without a helper.
But of course I won't argue, this is up to you.

My only point is, the kernel is already huge ;) Imho it makes sense to
try to lessen the code size, when the logic is simple.

Oleg.

