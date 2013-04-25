Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3DYOXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:23:34 -0400
Received: from relay.medianet-world.de ([213.157.0.172]:27931 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758137Ab3DYOXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:23:32 -0400
thread-index: Ac5BwE/oNggxLG2tSiu4cOyNxJ2dLQ==
Thread-Topic: [ANNOUNCE] 3.4.41-rt55-feat1
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Carsten Emde" <C.Emde@osadl.org>, "John Kacur" <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat1
Date: Thu, 25 Apr 2013 16:22:26 +0200
Message-ID: <3603730.i3rZKahVeu@dabox>
Organization: Hottinger Baldwin Messtechnik
User-Agent: KMail/4.10.2 (Linux/3.8.0+; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51792277.8000205@linutronix.de>
References: <1366760662.9609.176.camel@gandalf.local.home> <2156546.QlsX0XyPQz@dabox> <51792277.8000205@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset="us-ascii"
X-OriginalArrivalTime: 25 Apr 2013 14:22:26.0968 (UTC) FILETIME=[4FDC3180:01CE41C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian
> > I just wanted to test this release but it fails to compile with the the
> > following error:
> > 
> > kernel/hrtimer.c: In function '__hrtimer_start_range_ns':
> > kernel/hrtimer.c:1045:7: error: implicit declaration of function
> > 'hrtimer_rt_defer'
> > kernel/hrtimer.c: At top level:
> > kernel/hrtimer.c:1416:12: error: static declaration of 'hrtimer_rt_defer'
> > follows non-static declaration
> > kernel/hrtimer.c:1045:10: note: previous implicit declaration of
> > 'hrtimer_rt_defer' was here
> > 
> > The kernelconfig is attached.
> 
> You do not have CONFIG_HIGH_RES_TIMERS defined. Is this on purpose?
Yes, it's an tradeoff to get lower latencies for our VII (Very Important 
Interrupt :-). The idea is from Thomas Gleixner: We have an regular interrupt 
and define our own timer where which we call after we have finished our VII 
handler. But normally the HR_TIMER is set. So we switched it off on this very 
purpose. As we also have also PREEMPT_RT_FULL set the proposed solution to 
allow only PREEMPT_RT_FULL with PREEMPT_RT_FULL set is not an option for us.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich fur den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
