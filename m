Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaJBMlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaJBMlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:41:22 -0400
Date: Thu, 2 Oct 2014 14:40:43 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>
Subject: Re: [PATCH 2/4] mm: gup: add get_user_pages_locked and
 get_user_pages_unlocked
Message-ID: <20141002124043.GC2342@redhat.com>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
 <1412153797-6667-3-git-send-email-aarcange@redhat.com>
 <20141001155159.GA7019@google.com>
 <CAJu=L58vaT7BXfR+RHZ397zJJYL9KwozN0qzCQRadm-=wVYcUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJu=L58vaT7BXfR+RHZ397zJJYL9KwozN0qzCQRadm-=wVYcUw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:06:27AM -0700, Andres Lagar-Cavilla wrote:
> On Wed, Oct 1, 2014 at 8:51 AM, Peter Feiner <pfeiner@google.com> wrote:
> > On Wed, Oct 01, 2014 at 10:56:35AM +0200, Andrea Arcangeli wrote:
> >> +             /* VM_FAULT_RETRY cannot return errors */
> >> +             if (!*locked) {
> >> +                     BUG_ON(ret < 0);
> >> +                     BUG_ON(nr_pages == 1 && ret);
> >
> > If I understand correctly, this second BUG_ON is asserting that when
> > __get_user_pages is asked for a single page and it is successfully gets the
> > page, then it shouldn't have dropped the mmap_sem. If that's the case, then
> > you could generalize this assertion to
> >
> >                         BUG_ON(nr_pages == ret);

Agreed.

> 
> Even more strict:
>      BUG_ON(ret >= nr_pages);

Agreed too, plus this should be quicker than my weaker check.

Maybe some BUG_ON can be deleted later or converted to VM_BUG_ON, but
initially I feel safer with the BUG_ON considering that is a slow
path.

> Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>

Thanks!
