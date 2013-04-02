Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136Ab3DBSUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:20:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58510 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760543Ab3DBSUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:20:39 -0400
Date: Tue, 2 Apr 2013 14:19:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130402181940.GA4936@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
	Jiri Slaby <jslaby@suse.cz>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
 <20130402151436.GC31577@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402151436.GC31577@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I tried to reproduce the problem, and so I installed systemtap
(bleeding edge, since otherwise it won't work with development
kernel), and then rebuilt a kernel with all of the necessary CONFIG
options enabled:

	CONFIG_DEBUG_INFO, CONFIG_KPROBES, CONFIG_RELAY, CONFIG_DEBUG_FS,
	CONFIG_MODULES, CONFIG_MODULE_UNLOAD

I then pulled down mmtests, and tried running watch-dstate.pl, which
is what I sasume you were using, and I got a reminder of why I've
tried very hard to use systemtap:

semantic error: while resolving probe point: identifier 'kprobe' at /tmp/stapdjN4_l:18:7
        source: probe kprobe.function("get_request_wait")
                      ^

semantic error: no match
semantic error: while resolving probe point: identifier 'kprobe' at :74:8
        source: }probe kprobe.function("get_request_wait").return
                       ^

Pass 2: analysis failed.  [man error::pass2]
Unexpected exit of STAP script at ./watch-dstate.pl line 296.

I have no clue what to do next.  Can you give me a hint?

Thanks,

						- Ted
