Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967855Ab3DSCU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 22:20:58 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:52563 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967156Ab3DSCU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:20:57 -0400
In-Reply-To: <51700475.7050102@linux.intel.com>
References: <OF79A40956.94F46B9C-ON48257B50.00320F73-48257B50.0036925D@zte.com.cn> <516EAF31.8000107@linux.intel.com> <516EBF23.2090600@sr71.net> <516EC508.6070200@linux.intel.com> <OF7B3DF162.973A9AD7-ON48257B51.00299512-48257B51.002C7D65@zte.com.cn> <51700475.7050102@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
MIME-Version: 1.0
X-KeepSent: D8FA3C9D:ACFCFB28-48257B52:0008A691;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFD8FA3C9D.ACFCFB28-ON48257B52.0008A691-48257B52.000C4DFB@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Fri, 19 Apr 2013 10:13:43 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-19 10:13:38,
	Serialize complete at 2013-04-19 10:13:38
Content-Type: text/plain; charset="GB2312"
X-MAIL: mse01.zte.com.cn r3J2DxT3036700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3J2L1sk020997

Darren Hart <dvhart@linux.intel.com> wrote on 2013/04/18 22:34:29:

> On 04/18/2013 01:05 AM, zhang.yi20@zte.com.cn wrote:
> > 
> > I have run futextest/performance/futex_wait for testing, 
> >  5 times before make it long:
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 10215 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 9862 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 10081 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 10060 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 10081 Kiter/s
> > 
> > 
> > And 5 times after make it long:
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 9940 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 10204 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 9901 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 10152 Kiter/s
> > 
> > futex_wait: Measure FUTEX_WAIT operations per second
> >         Arguments: iterations=100000000 threads=256
> > Result: 10060 Kiter/s
> > 
> > 
> > Seems OK, is it?
> > 
> 
> Changes appear to be in the noise, no impact with this load 
> anyway.
> How many CPUs on your test machine? I presume not 256?
> 
> -- 

There are 16 CPUs£¬ and mode is:
Intel(R) Xeon(R) CPU           C5528  @ 2.13GHz

Shall I make the number of threads as the CPUS? I test again with argument 
'-n 16', the result is similar.

BTW, have you seen the testcase in my other mail?  It seems to be rejected 
by LKML.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
