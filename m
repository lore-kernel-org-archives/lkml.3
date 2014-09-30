Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaI3QFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaI3QF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:05:28 -0400
Date: Tue, 30 Sep 2014 12:05:10 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: pipe/page fault oddness.
Message-ID: <20140930160510.GA15903@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Michel Lespinasse <walken@google.com>
References: <20140930033327.GA14558@redhat.com>
 <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
 <20140930043309.GA16196@redhat.com>
 <CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
 <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 08:52:08AM -0700, Linus Torvalds wrote:

 > So if it's looping on that fault, what seems to happen is that the
 > page fault keeps happening.
 > 
 > Can you recreate this? Because if you can, please try to revert commit
 > e4a1cc56e4d7 ("x86: mm: drop TLB flush from ptep_set_access_flags").
 > Maybe the TLB has it read-only, and it doesn't get flushed, and the
 > page fault happens over and over again.

I left it spinning overnight in case someone wanted me to probe it
further, so I haven't tried reproducing it yet.  It took ~12 hours
yesterday before it got in that state.  I'll restart it, and tell it
to only use pipe fd's, which might speed things up a little.

If I can reproduce it, I'll then try that revert.

 > What kind of CPU is the problematic machine? There was some question
 > about just how architectural the whole "TLB entry causing a page fault
 > gets invalidated automatically" really is.

model name	: Intel(R) Core(TM) i5-4670T CPU @ 2.30GHz

	Dave

