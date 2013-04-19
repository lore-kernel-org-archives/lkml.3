Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3DSHE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:04:28 -0400
Received: from mx5.zte.com.cn ([63.217.80.70]:45245 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755979Ab3DSHEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:04:25 -0400
In-Reply-To: <51700926.8020309@linux.intel.com>
References: <OF1AAB4598.9A9CCAE8-ON48257B51.000416F3-48257B51.0009DE5A@zte.com.cn> <51700926.8020309@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH] futex: bugfix for robust futex deadlock when waking only
 one thread in handle_futex_death
MIME-Version: 1.0
X-KeepSent: DA934C0C:B786F653-48257B52:0022A88B;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFDA934C0C.B786F653-ON48257B52.0022A88B-48257B52.0026D852@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Fri, 19 Apr 2013 15:03:37 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-19 15:03:33,
	Serialize complete at 2013-04-19 15:03:33
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: mse02.zte.com.cn r3J73qWM097691
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart <dvhart@linux.intel.com> wrote on 2013/04/18 22:54:30:

> 
> "or it will exit later" .... I don't follow you there, it sounds like
> you are saying if we try to wake the exiting process, that process will
> be delayed and take longer to exit.... I don't think that is what you
> meant. Can you elaborate please?
> 

I want to describe this scene:
1, We wake one waiter of other process that is not exiting.
2, Before it returns from do_futex, another thread of the process 
  encounters an exception and leads to process exiting.
3, The waiter returns from do_futex, and handle exit signal first, 
  that it will not return to userspace any more.

So, to my way of thinking, to choose a suitable waiter is difficult.

