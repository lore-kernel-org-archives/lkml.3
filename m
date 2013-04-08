Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936819Ab3DHKy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935424Ab3DHKyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:54:24 -0400
Date: Mon, 8 Apr 2013 06:52:53 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130408105253.GA5275@redhat.com>
References: <20130402142717.GH32241@suse.de> <20130402150651.GB31577@thunk.org> <20130402151436.GC31577@thunk.org> <20130402181940.GA4936@thunk.org> <y0mwqsehuj9.fsf@fche.csb> <20130408083645.GC2623@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408083645.GC2623@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mel -

> > [...]  git kernel developers
> > should use git systemtap, as has always been the case.  [...]
> 
> At one point in the past this used to be the case but then systemtap had to
> be compiled as part of automated tests across different kernel versions. It
> could have been worked around in various ways or even installed manually
> when machines were deployed but stap-fix.sh generally took less time to
> keep working.

OK, if that works for you.  Keep in mind though that newer versions of
systemtap retain backward-compatibility for ancient versions of the
kernel, so git systemtap should work on those older versions just
fine.


> [...]
> Yes, this was indeed the problem. The next version of watch-dstate.pl
> treated get_request_wait() as a function that may or may not exist. It
> uses /proc/kallsyms to figure it out.

... or you can use the "?" punctuation in the script to have
systemtap adapt:

    probe kprobe.function("get_request_wait") ?  { ... }


- FChE
