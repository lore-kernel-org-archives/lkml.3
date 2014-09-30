Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaI3QHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:07:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaI3QHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:07:45 -0400
Date: Tue, 30 Sep 2014 12:07:29 -0400
From: Dave Jones <davej@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: pipe/page fault oddness.
Message-ID: <20140930160729.GB15903@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Michel Lespinasse <walken@google.com>
References: <20140930033327.GA14558@redhat.com>
 <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
 <20140930043309.GA16196@redhat.com>
 <CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
 <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
 <542AD43A.90706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542AD43A.90706@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:03:06PM -0400, Rik van Riel wrote:

 > > What kind of CPU is the problematic machine? There was some
 > > question about just how architectural the whole "TLB entry causing
 > > a page fault gets invalidated automatically" really is.
 > 
 > Intel people told me at the time that the guarantee was architectural.
 > I don't know whether other x86 manufacturers know this...
 > 
 > Doing a local tlb flush from ptep_set_access_flags seems appropriate,
 > if that is indeed the issue.
 > 
 > On the other hand, do_wp_page does not seem to do a tlb flush when
 > the old page is reused, so CPUs do get rid of inappropriate TLB
 > entries. We would have noticed do_wp_page not working right :)
 
The puzzling thing is we've had that code change for two years
without issue. This isn't a new machine, so why would it only
be showing up bad effects now ?

	Dave

