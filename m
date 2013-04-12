Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3DLJBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:01:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37330
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab3DLJBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:01:02 -0400
Message-ID: <1365757243.17140.28.camel@laptop>
Subject: Re: sw_perf_event_destroy() oops while fuzzing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Date: Fri, 12 Apr 2013 11:00:43 +0200
In-Reply-To: <CA+ydwtrhpd2C3sK6B49qdoWg-k97gBXFDgnKXY2Mcb_wSsMiXQ@mail.gmail.com>
References: <CA+ydwtrhpd2C3sK6B49qdoWg-k97gBXFDgnKXY2Mcb_wSsMiXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 08:34 +0300, Tommi Rantala wrote:

> [92759.011005] RIP  [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90

> [114607.070003] RIP: 0010:[<ffffffff811a7200>]  [<ffffffff811a7200>]
> sw_perf_event_destroy+0x30/0x90

> [114607.070003] RIP  [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90

Would you have a source line for me that goes with that.. I can't seem
to poke any holes just by looking.

perf_swevent_init() only sets event->destroy() (to
sw_perf_event_destroy) _after_ it increments the static key thing and
enqueues (and allocates) the hash list stuff.

Obviously something is funny, but I'm not seeing it.

