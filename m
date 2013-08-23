Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3HWR4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:56:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:51545 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3HWR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:56:31 -0400
Date: Fri, 23 Aug 2013 19:56:28 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.9-rt5
Message-ID: <20130823175628.GA9130@linutronix.de>
References: <20130822182127.GA7606@linutronix.de>
 <5216F81A.4050203@localhost>
 <52170A6F.6040009@linutronix.de>
 <52179950.6010601@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52179950.6010601@localhost>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fernando Lopez-Lezcano | 2013-08-23 10:18:08 [-0700]:

>Please post a patch when/if you have it so I can retry the build...
>Thanks for taking a look at this!

Does this fix your trobule?

diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index 0bfa40d..6f61d5f 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -220,7 +220,7 @@ static struct sample *buffer_get_sample(struct sample *sample)
 #else
 #define time_type	u64
 #define time_get()	trace_clock_local()
-#define time_to_us(x)	((x) / 1000)
+#define time_to_us(x)	div_u64(x, 1000)
 #define time_sub(a, b)	((a) - (b))
 #define init_time(a, b)	a = b
 #define time_u64(a)	a

>-- Fernando

Sebastian
