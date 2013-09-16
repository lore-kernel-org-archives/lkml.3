Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3IPJXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:23:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab3IPJXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:23:49 -0400
Date: Mon, 16 Sep 2013 11:23:47 +0200
From: Jan Kara <jack@suse.cz>
To: axboe@kernel.dk
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: BLK_TN_PROCESS events not delivered for all devices
Message-ID: <20130916092347.GB19027@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  I've been looking into a problem where BLK_TN_PROCESS events are not
delivered to all devices which are being traced. This results in process
name being (null) when trace for a single device is parsed.

The reason for this problem is that trace_note_tsk() is called only if
tsk->btrace_seq != blktrace_seq and it updates tsk->btrace_seq to
blktrace_seq. Thus after a trace for another device is started
BLK_TN_PROCESS event is sent only on behalf of the first device with which
the task interacts. That isn't necessarily the new device thus traces for
some devices accumulate several BLK_TN_PROCESS events for one task while
other have none. Is this a known problem and is this intended to work
better?

I was thinking how to fix that for a while and it doesn't seem to be
possible without tracking with each block trace which tasks it has been
notified about. And that is relatively expensive...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
