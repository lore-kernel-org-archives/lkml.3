Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3DPNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:09:58 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:55419 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3DPNJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:09:56 -0400
Date: Tue, 16 Apr 2013 15:09:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/3 v2] mutex: Improve mutex performance by doing less
 atomic-ops & better spinning
Message-ID: <20130416130951.GB20961@gmail.com>
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com>
 <20130416091259.GC9569@gmail.com>
 <516D3ADE.9060606@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516D3ADE.9060606@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> On 04/16/2013 05:12 AM, Ingo Molnar wrote:
> >* Waiman Long<Waiman.Long@hp.com>  wrote:
> >
> >>[...]
> >>
> >>Patches 2 improves the mutex spinning process by reducing contention among the
> >>spinners when competing for the mutex. This is done by using a MCS lock to put
> >>the spinners in a queue so that only the first spinner will try to acquire the
> >>mutex when it is available. This patch showed significant performance
> >>improvement of +30% on the AIM7 fserver and new_fserver workload.
> >Ok, that's really nice - and this approach has no arbitrary limits/tunings in it.
> >
> >Do you have a performance comparison to your first series (patches 1+2+3 IIRC) -
> >how does this new series with MCS locking compare to the best previous result from
> >that old series? Do we now achieve that level of performance?
> 
> Compared with the old patch set, the new patches 1+2 have over 30%
> performance gain in high user load (1100-1500) in the fserver and
> new_fserver workloads. The old patches 1+2 or 1+3 only manages
> around 10% gain. In the intermediate range of 200-1000, the 2 sets
> are more comparable in performance gain.

Ok, that's cool!

Thanks,

	Ingo
