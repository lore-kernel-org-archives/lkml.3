Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaCMVob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:44:31 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:49974 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCMVo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwqTbsYCyPf6_i6RmBkPHpEhJjiRfZm6_1_yPa_kUkYiQ@mail.gmail.com>
References: <20140308194405.GA32403@redhat.com>
	<CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
	<20140309125710.GA1829@redhat.com>
	<CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com>
	<20140309170909.GA13335@redhat.com>
	<CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com>
	<1394481375.3867.1.camel@buesod1.americas.hpqcorp.net>
	<20140313145941.GA26215@redhat.com>
	<CA+55aFyNd7L+G3hFauJPxUOengK-_o2G-SFmVooPZ-sE6xBj=g@mail.gmail.com>
	<20140313163632.GA30737@redhat.com>
	<20140313182702.GA3429@redhat.com>
	<CA+55aFwqTbsYCyPf6_i6RmBkPHpEhJjiRfZm6_1_yPa_kUkYiQ@mail.gmail.com>
Date: Thu, 13 Mar 2014 14:44:28 -0700
X-Google-Sender-Auth: X5GBqjDV3UPBGiHPXQ0DkBaoleA
Message-ID: <CA+55aFzBjMQGapsS1Jw3rdrPaOYYPn7NamtjN47_W_r1QKX+8Q@mail.gmail.com>
Subject: Re: async_pf.c && use_mm() (Was: mm,vmacache: also flush cache for VM_CLONE)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davi@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Michel Lespinasse <walken@google.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Maybe it uses use_mm just to increment the usage count. Which is bogus, and
> it should just "get" it instead, but whatever.
>
> On my phone, so I can't check the details.

Ok, no longer on my phone, and no, it clearly does the reference count with a

    atomic_inc(&work->mm->mm_count);

separately. The use_mm/unuse_mm seems entirely specious.

Maybe it has some historical meaning to it.

               Linus
