Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaEBGvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 02:51:14 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33310 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaEBGvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 02:51:13 -0400
Message-ID: <1399013469.5233.85.camel@marge.simpson.net>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Date: Fri, 02 May 2014 08:51:09 +0200
In-Reply-To: <1399012619.5233.76.camel@marge.simpson.net>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	 <1399008721.5233.35.camel@marge.simpson.net>
	 <1399010337.5233.50.camel@marge.simpson.net> <53633645.9090308@redhat.com>
	 <1399012619.5233.76.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 08:36 +0200, Mike Galbraith wrote:

> Reason why is that case was on a box where FAIR_SLEEPERS is disabled by
> default, meaning there is no such thing as wakeup preemption.  Guess
> what happens when you don't have shared LLC for a fast/light wakee to
> escape to when the waker is a pig.  The worst thing possible in that
> case is to wake affine.  Leave the poor thing wherever it was, else it
> will take a latency hit that need not have been.

Oh yeah, and you'll see similar issues playing with kvm.  No escape
routes are available, as no llc domain exists.  Globally do a sync
wakeup CPU affine, and for some loads that will induce massive wreckage
where as If select_isle_sibling() had been there to save the day, all
would have been peachy.  Is it good, or is it evil... depends.

-Mike

