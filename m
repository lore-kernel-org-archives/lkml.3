Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab3CHSAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:00:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759799Ab3CHSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:00:49 -0500
Date: Fri, 8 Mar 2013 18:58:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/3] coredump: signal_pending() checks and cleanups
Message-ID: <20130308175852.GA26300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

To remind, this replaces the previous series,

	coredump-factor-out-the-setting-of-pf_dumpcore.patch
	freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
	coredump-make-wait_for_dump_helpers-freezable.patch

As Mandeep pointed out, 2/3 is not enough to make the coredump really
freezable.

By discussion with Mandeep, we simply accept the fact that the freezer
can truncate a core-dump, hopefully not a problem in practice.

2 and 3 become the "off-topic" cleanups but imho make sense anyway and
can help if we decide to make the coredumping freezable.

Mandeep, I didn't dare to keep your ack on 3/3, the patch was updated
a bit (s/freezable/interruptible + comments), I hope you can ack v2 too.
And of course I hope you will review 1 and 2 as well.

Oleg.

