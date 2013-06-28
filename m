Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3F1Ps6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:48:58 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:48127 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab3F1Ps5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:48:57 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Topic: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Thread-Index: AQHOcRh6tLsjeasi80i72tgopT7X3plLdn2A///IhNCAAEx9AP//v98g
Date: Fri, 28 Jun 2013 15:48:02 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E0FEEB@USINDEM103.corp.hds.com>
References: <51C8AA31.3070208@hds.com>
	 <1372429303.18733.325.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D443E0FE25@USINDEM103.corp.hds.com>
 <1372433814.18733.335.camel@gandalf.local.home>
In-Reply-To: <1372433814.18733.335.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-28_07:2013-06-28,2013-06-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1306280106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5SFn853021858

> > +void smp_trace_reschedule_interrupt(struct pt_regs *regs)
> > +{
> 
> Sure, but we should probably add a comment here to why
> smp_trace_reschedule_interrupt() is different than
> smp_reschedule_interrupt().
> 
> 	/*
> 	 * Need to call irq_enter() before calling the trace point.
> 	 * __smp_reschedule_interrupt() calls irq_enter/exit() too (in
> 	 * scheduler_ipi(). This is OK, since those functions are allowed
> 	 * to nest.
> 	 */
> 
> -- Steve

I will add the comment.

Thanks.

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
