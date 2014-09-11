Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaIKQE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:04:27 -0400
Received: from mx0.aculab.com ([213.249.233.131]:41970 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755152AbaIKQEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:04:25 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Aaron Tomlin'" <atomlin@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "dzickus@redhat.com" <dzickus@redhat.com>,
        "jcastillo@redhat.com" <jcastillo@redhat.com>,
        "riel@redhat.com" <riel@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "mingo@kernel.com" <mingo@kernel.com>,
        "bmr@redhat.com" <bmr@redhat.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "akpm@google.com" <akpm@google.com>, "jgh@redhat.com" <jgh@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pzijlstr@redhat.com" <pzijlstr@redhat.com>
Subject: RE: [PATCH v3 0/3] sched: Always check the integrity of the canary
Thread-Topic: [PATCH v3 0/3] sched: Always check the integrity of the canary
Thread-Index: AQHPzdccI6w9GrgG8UuGJPEpxz0/G5v8FsrA
Date: Thu, 11 Sep 2014 16:02:45 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17490245@AcuExch.aculab.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
In-Reply-To: <1410450088-18236-1-git-send-email-atomlin@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8BG4VKj027182

From: Aaron Tomlin
> Currently in the event of a stack overrun a call to schedule()
> does not check for this type of corruption. This corruption is
> often silent and can go unnoticed. However once the corrupted
> region is examined at a later stage, the outcome is undefined
> and often results in a sporadic page fault which cannot be
> handled.
> 
> The first patch adds a canary to init_task's end of stack.
> While the second patch provides a helper to determine the
> integrity of the canary. The third checks for a stack
> overrun and takes appropriate action since the damage
> is already done, there is no point in continuing.

Clearly you've just been 'bitten' by a kernel stack overflow.
But a simple 'canary' isn't going to find most of the overflows
and will give an incorrect 'sense of security'.

The canary will only work if the stack is densely written.
In practise the stack alignment rules create gaps, and the
most likely reason for overflow is a large on-stack buffer
that isn't actually written to.

The only real way to detect kernel stack overflow is to arrange
for an unmapped page beyond the stack.
That costs KVA, but not much else.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
