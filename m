Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaBMW4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:56:42 -0500
Received: from smtp3.Stanford.EDU ([171.67.219.83]:51156 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752221AbaBMW4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:56:40 -0500
Message-ID: <52FD4D89.2000207@localhost>
Date: Thu, 13 Feb 2014 14:56:09 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.9-rt13: BUG: soft lockup
References: <52FBF2F1.8040504@localhost> <alpine.DEB.2.02.1402132324230.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402132324230.21991@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 02:25 PM, Thomas Gleixner wrote:
> On Wed, 12 Feb 2014, Fernando Lopez-Lezcano wrote:
>> [771508.546449] RIP: 0010:[<ffffffff810dc60a>]  [<ffffffff810dc60a>]
>> smp_call_function_many+0x2ca/0x330
>
> Can you decode the exact location inside of smp_call_function_many via
> addr2line please ?

Hope this is useful (adding 0x2ce/0x330 as offsets does not make any 
difference, don't know if it should)...

# grep smp_call_function /var/log/messages|tail -1
Feb 12 14:18:21 cmn27 kernel: [771840.224419] RIP: 
0010:[<ffffffff810dc60e>]  [<ffffffff810dc60e>] 
smp_call_function_many+0x2ce/0x330
# addr2line -e 
/usr/lib/debug/lib/modules/3.12.10-300.rt15.1.fc20.ccrma.x86_64+rt/vmlinux 
  ffffffff810dc60e
/usr/src/debug/kernel-3.12.fc20.ccrma/linux-3.12.10-300.rt15.1.fc20.ccrma.x86_64/kernel/rtmutex.c:1295

This is the only time I was able to catch some logs of the problem (if 
it is the same). I had to revert to 3.10.27-rt25 for the time being and 
that seems to be holding up well so far.

-- Fernando
