Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155Ab3DCMaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668Ab3DCMao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:30:44 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>
Subject: Re: systemtap broken by removal of register_timer_hook
References: <20130403075017.GA2534@suse.de>
	<CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 03 Apr 2013 08:29:48 -0400
In-Reply-To: <CAFTL4hyYezB2ZxM-GJ70VoxOeRSG64V6u+nX2hTuhF30R-GdPg__32168.962484184$1364986928$gmane$org@mail.gmail.com> (Frederic Weisbecker's message of "Wed, 3 Apr 2013 13:01:23 +0200")
Message-ID: <y0mvc83u79f.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]
> Sometimes I don't mind keeping around code in the kernel for out of
> tree users, depending on the case. But in this specific matter we have
> more standard ways to do this kind of hook: kprobes, static
> tracepoints. A tracepoint on the timer tick would be useful BTW, and
> you could reuse it.

Thanks for noticing!  IMO kprobes would be too heavyweight for this.
A new static tracepoint would be fine, especially if it passes the
same pt_regs* pointer as the former hook did.

- FChE
