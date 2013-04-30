Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231Ab3D3KfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 06:35:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:60305 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759915Ab3D3KfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 06:35:03 -0400
Date: Tue, 30 Apr 2013 12:35:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Clark Williams <williams@redhat.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org
Subject: Re: [ANNOUNCE] 3.8.10-rt6
Message-ID: <20130430103500.GA4688@linutronix.de>
References: <20130429201202.GB7979@linutronix.de>
 <20130429161925.2a6ea78a@riff.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130429161925.2a6ea78a@riff.lan>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Clark Williams | 2013-04-29 16:19:25 [-0500]:

>On Mon, 29 Apr 2013 22:12:02 +0200
>Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>>     - suspend / resume seems to program program the timer wrong and wait
>>       ages until it continues.
>> 
>
>It has to be something we're doing when we apply RT to v3.8.x, since
>v3.8.x suspends/resumes with no issues and I was able to suspend and
>resume fine with the 3.6-rt series. 

Are your problems gone with:

diff --git a/kernel/printk.c b/kernel/printk.c
index 6d52c34..8783ea5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1583,6 +1583,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 */
 	if (unlikely(forced_early_printk(fmt, args)))
 		return 1;
+	if (in_nmi())
+		return 1;
 
 	boot_delay_msec(level);
 	printk_delay();

>Clark

Sebastian
