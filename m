Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaAXVBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:01:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaAXVB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:01:28 -0500
Date: Fri, 24 Jan 2014 16:00:52 -0500
From: Dave Jones <davej@redhat.com>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        trinity@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_rr_get_interval NULL pointer OOPS
Message-ID: <20140124210052.GB6838@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, trinity@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <CA+ydwtpvqv7pHFiQsPX+DeRyjKVvxvS2SKxXEttdT=PQr6qqFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ydwtpvqv7pHFiQsPX+DeRyjKVvxvS2SKxXEttdT=PQr6qqFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 10:55:56PM +0200, Tommi Rantala wrote:
 > Hello,
 > 
 > Trinity triggered the following bug in two separate qemu virtual
 > machines after fuzzing v3.13-3995-g0dc3fd0 for a day or two. I have
 > not been running Trinity in a while, so no idea if this is a
 > regression or not.
 
Probably been there a while. I noticed on Tuesday that I hadn't annotated
the 'policy' argument to sched_setscheduler().  Now that it's passing sensible
arguments, I'm not surprised there's some fallout if subsequent syscalls
call misc scheduler functions.

	Dave

