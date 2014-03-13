Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbaCMS16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:27:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbaCMS14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:27:56 -0400
Date: Thu, 13 Mar 2014 19:27:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Gleb Natapov <gleb@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davi@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: async_pf.c && use_mm() (Was: mm,vmacache: also flush cache for
	VM_CLONE)
Message-ID: <20140313182702.GA3429@redhat.com>
References: <20140308194405.GA32403@redhat.com> <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com> <20140309125710.GA1829@redhat.com> <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com> <20140309170909.GA13335@redhat.com> <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com> <1394481375.3867.1.camel@buesod1.americas.hpqcorp.net> <20140313145941.GA26215@redhat.com> <CA+55aFyNd7L+G3hFauJPxUOengK-_o2G-SFmVooPZ-sE6xBj=g@mail.gmail.com> <20140313163632.GA30737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313163632.GA30737@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Oleg Nesterov wrote:
>
> Hmm, but at first glance async_pf_execute() doesn't need use_mm() at all.

Seriously, why it nees use_mm? get_user_pages(mm => apf->mm) should work.
Perhaps there is some kvm magic ?

But actually I am writing this email because mmdrop() doesn't look right
or I missed something. I think that kvm_setup_async_pf() should increment
->mm_users and async_pf_execute() needs mmput() ?

Oleg.

