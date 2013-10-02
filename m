Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3JBWew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:34:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab3JBWeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:34:50 -0400
Date: Wed, 2 Oct 2013 18:34:37 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrey Konovalov <andreyknvl@google.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com,
        Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>
Subject: Re: Fwd: Potential out-of-bounds in ftrace_regex_release
Message-ID: <20131002223437.GA15728@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrey Konovalov <andreyknvl@google.com>,
	linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com,
	Dmitry Vyukov <dvyukov@google.com>,
	Kostya Serebryany <kcc@google.com>
References: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
 <CAAeHK+wy+vs2PniKh8DbWzZoS99g1eZ-U3mv+6SzoznC8WHW6A@mail.gmail.com>
 <20131002185723.GA32614@redhat.com>
 <1380745082.12351.6.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380745082.12351.6.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:18:02PM -0400, Steven Rostedt wrote:
 > On Wed, 2013-10-02 at 14:57 -0400, Dave Jones wrote:
 > 
 > > And that's the cause. I wonder what was being opened.
 > > Do you happen to have a trinity-child log for that thread ?
 > 
 > Thanks for the update. This definitely looks like the bug, and explains
 > a lot. I'll look into this, as I'm currently at a conference, it may be
 > sporadic.

another potential clue.. I looked over some logs from some crashes, and saw that just before
the crash, there was a call to unshare(), after which the uid changed from 1000 to 65534.
Is that something that ftrace is prepared for ?

	Dave

