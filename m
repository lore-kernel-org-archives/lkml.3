Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaIBVW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:22:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbaIBVW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:22:58 -0400
Date: Tue, 2 Sep 2014 23:22:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bryan Wu <cooloney@gmail.com>
cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "leds: convert blink timer to workqueue"
In-Reply-To: <CAK5ve-KnjD58aAsqdtYSNgmZt7mNCP5fsr809y7D1_AtBaB7wg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1409022322330.12309@pobox.suse.cz>
References: <alpine.LNX.2.00.1409021101450.2481@pobox.suse.cz> <CAK5ve-KnjD58aAsqdtYSNgmZt7mNCP5fsr809y7D1_AtBaB7wg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Bryan Wu wrote:

> On Tue, Sep 2, 2014 at 2:03 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> > This reverts commit 8b37e1bef5a6b60e949e28a4db3006e4b00bd758.
> >
> > It's broken as it changes led_blink_set() in a way that it can now sleep
> > (while synchronously waiting for workqueue to be cancelled). That's a
> > problem, because it's possible that this function gets called from atomic
> > context (tpt_trig_timer() takes a readlock and thus disables preemption).
> >
> > This has been brought up 3 weeks ago already [1] but no proper fix has
> > materialized, and I keep seeing the problem since 3.18-rc1.
> 
> Is this 3.18-rc1? I think it should be 3.17-rc1, right?

Indeed, brainfart on my side, thanks for noticing.

-- 
Jiri Kosina
SUSE Labs
