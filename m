Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375Ab3DDQtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:49:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52471
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763197Ab3DDQta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:49:30 -0400
Message-ID: <1365094158.2609.119.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Date: Thu, 04 Apr 2013 18:49:18 +0200
In-Reply-To: <20130404133123.GW2228@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop> <1365076908.2609.94.camel@laptop>
	 <20130404133123.GW2228@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> We've discussed this approach of using (rt-prio, age) instead of just
> age
> to determine the the "oldness" of a task for deadlock-breaking with
> -EAGAIN. The problem is that through PI boosting or normal rt-prio
> changes
> while tasks are trying to acquire ww_mutexes you can create acyclic
> loops
> in the blocked-on graph of ww_mutexes after the fact and so cause
> deadlocks. So we've convinced ourselves that this approche doesn't
> work.

Could you pretty please draw me a picture, I'm having trouble seeing
what you mean.

AFAICT as long as you boost Y while its the lock owner things should
work out, no?



