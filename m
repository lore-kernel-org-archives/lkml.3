Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3KLPEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:04:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33492 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3KLPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:04:21 -0500
Date: Tue, 12 Nov 2013 16:04:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: Delete file if a failure occurs writing the
 perf data file
Message-ID: <20131112150410.GW5056@laptop.programming.kicks-ass.net>
References: <1383928906-31470-1-git-send-email-dsahern@gmail.com>
 <20131111093747.GA14810@gmail.com>
 <5280ECFF.10103@gmail.com>
 <52824064.4060100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52824064.4060100@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 07:51:16AM -0700, David Ahern wrote:
> > From man mmap:
> >        SIGBUS Attempted access to a portion of the buffer that
> >        does not correspond  to  the  file (for  example, beyond
> >        the end of the file, ...

SIGBUS is basically the std fail for any fault; there's a ton more
reasons than listed in that manpage.

Failing to dirty a page due to -ENOSPACE is one reason we'll
trigger SIGBUS -- as you already found in that memcpy to mmap() instead
of write() patch.


