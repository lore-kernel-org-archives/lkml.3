Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935308Ab3FSXlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:41:32 -0400
Received: from longford.logfs.org ([213.229.74.203]:59624 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:41:31 -0400
Date: Wed, 19 Jun 2013 18:11:25 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Ellingsworth <david@identd.dyndns.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Michael Buesch <mb@bu3sch.de>, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softirq: weaken warning in local_bh_enable_ip()
Message-ID: <20130619221125.GA10834@logfs.org>
References: <1371658756-7580-1-git-send-email-joern@logfs.org>
 <CA+55aFyBL9S9y=kpBte67PfO6EaB79CP3JtMP3KwMWQfo3PrFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyBL9S9y=kpBte67PfO6EaB79CP3JtMP3KwMWQfo3PrFg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 June 2013 12:27:37 -1000, Linus Torvalds wrote:
> 
> No the warning is correct, the SCSI target code needs to be fixed. You
> cannot call spin_unlock_bh with interrupts disabled.

That sounds like something coverity could be taught with reasonable
effort - if someone from them is listening.  Not sure if sparse has
enough context to do the same.

Just to play thick and make things ultra-clear, you say the following
pattern is never legal, correct?

spin_lock_irq(save)
...
spin_lock_bh
...
spin_unlock_bh
...
spin_unlock_irq(restore)

> So fix the code, don't weaken the warning.

Will do.

Jörn

--
The only real mistake is the one from which we learn nothing.
-- John Powell
