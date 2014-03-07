Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaCGNNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:13:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:37439 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaCGNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:13:49 -0500
Date: Fri, 7 Mar 2014 14:13:41 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.9-rt13: BUG: soft lockup
Message-ID: <20140307131341.GC8637@linutronix.de>
References: <52FBF2F1.8040504@localhost>
 <alpine.DEB.2.02.1402132324230.21991@ionos.tec.linutronix.de>
 <52FD4D89.2000207@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52FD4D89.2000207@localhost>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fernando Lopez-Lezcano | 2014-02-13 14:56:09 [-0800]:

>On 02/13/2014 02:25 PM, Thomas Gleixner wrote:
>>On Wed, 12 Feb 2014, Fernando Lopez-Lezcano wrote:
>>>[771508.546449] RIP: 0010:[<ffffffff810dc60a>]  [<ffffffff810dc60a>]
>>>smp_call_function_many+0x2ca/0x330
>>
>>Can you decode the exact location inside of smp_call_function_many via
>>addr2line please ?
>
>Hope this is useful (adding 0x2ce/0x330 as offsets does not make any
>difference, don't know if it should)...

ffffffff810dc60a is the location where the CPU is atm. The address of
smp_call_function_many() + 0x2ca should give the same value. 0x330 says
that the function is 0x330 bytes in size. 
that means, if you do the math, you learn that smp_call_function_many()
starts at 0xffffffff810dc340 and ends at 0xffffffff810dc66f.

Sebastian
