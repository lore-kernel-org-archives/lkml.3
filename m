Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbbAVTfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:35:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:32992 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbAVTfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:35:43 -0500
Date: Thu, 22 Jan 2015 20:35:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olliver Schinagl <o.schinagl@ultimaker.com>
cc: linux-kernel@vger.kernel.org, Olliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH] hrtimer: add hrtimer_start_now()
In-Reply-To: <54C0D9D7.4010903@ultimaker.com>
Message-ID: <alpine.DEB.2.11.1501222032570.5526@nanos>
References: <1421907161-5744-1-git-send-email-o.schinagl@ultimaker.com> <alpine.DEB.2.11.1501221153320.5526@nanos> <54C0D9D7.4010903@ultimaker.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Olliver Schinagl wrote:
> On 22-01-15 12:01, Thomas Gleixner wrote:
> > Aside of that, what's wrong with doing:
> > 
> >        static const ktime_t ktime_zero = { .tv64 = 0 };
> > 
> >        hrtimer_start(timer, ktime_zero, HRTIMER_MODE_REL);
> I guess the same could be said for hrtimer_forward_now I suppose. It was just
> intended as a little helper, with emphasis on helper.

Well, no. htimer_forward_now() is mainly there to maintain a periodic
schedule which takes gaps into account.

I have nothing against the start_now() helper, but it's simpler and
less code with start relative than with abs and get_time().

Thanks,

	tglx
