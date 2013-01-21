Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3AUBxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:53:53 -0500
Received: from ozlabs.org ([203.10.76.45]:55763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3AUBxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:53:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Add TAINT_NOKEY_MODULE
In-Reply-To: <20130121001939.GB25509@redhat.com>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org> <87bod14x44.fsf@rustcorp.com.au> <20130107145832.GA12363@hansolo.jdub.homelinux.org> <20130115190911.GA6964@hansolo.jdub.homelinux.org> <87y5ftyf51.fsf@rustcorp.com.au> <20130116193724.GF6964@hansolo.jdub.homelinux.org> <87pq14y6bs.fsf@rustcorp.com.au> <20130117150202.GB32586@redhat.com> <8738xvxv55.fsf@rustcorp.com.au> <20130121001939.GB25509@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Jan 2013 12:20:08 +1030
Message-ID: <87a9s3wbhr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Frank Ch. Eigler" <fche@redhat.com> writes:
> Hi -
>
>> [...]
>> -	add_taint(TAINT_DIE);
>> +	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
>> [...]
>
> If "UNRELIABLE" a good way to describe it - not DANGEROUS or
> COUNTERPRODUCTIVE or something, then maybe lockdep *can* produce
> reasonable results following such a taint.  If the results are merely
> suspect, could lockdep reports include the taint report, but otherwise
> keep working?

git blame is your friend here:

commit 2c16e9c888985761511bd1905b00fb271169c3c0
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Mon Jul 10 04:45:42 2006 -0700

    [PATCH] lockdep: disable lock debugging when kernel state becomes untrusted
    
    Disable lockdep debugging in two situations where the integrity of the
    kernel no longer is guaranteed: when oopsing and when hitting a
    tainting-condition.  The goal is to not get weird lockdep traces that don't
    make sense or are otherwise undebuggable, to not waste time.
    
    Lockdep assumes that the previous state it knows about is valid to operate,
    which is why lockdep turns itself off after the first violation it reports,
    after that point it can no longer make that assumption.
    
    A kernel oops means that the integrity of the kernel compromised; in
    addition anything lockdep would report is of lesser importance than the
    oops.
    
    All the tainting conditions are of similar integrity-violating nature and
    also make debugging/diagnosing more difficult.
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

Cheers,
Rusty.


