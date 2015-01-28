Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbbA2BRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:17:31 -0500
Received: from skprod2.natinst.com ([130.164.80.23]:51811 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753830AbbA2BR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:17:28 -0500
Message-ID: <54C94F73.3010006@ni.com>
Date: Wed, 28 Jan 2015 15:06:59 -0600
From: Xander Huff <xander.huff@ni.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
CC: linux-rt-users@vger.kernel.org, josh.cartwright@ni.com,
        gratian.crisan@ni.com, linux-kernel@vger.kernel.org,
        jaeden.amero@ni.com, ben.shelton@ni.com, brad.mouring@ni.com,
        rich.tollerton@ni.com
Subject: Re: [PATCH -rt] lockdep: selftest: fix warnings due to missing PREEMPT_RT
 conditionals
References: <1422472125-21979-1-git-send-email-xander.huff@ni.com>
In-Reply-To: <1422472125-21979-1-git-send-email-xander.huff@ni.com>
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/28/2015 03:06:59 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 01/28/2015 03:06:59 PM,
	Serialize complete at 01/28/2015 03:06:59 PM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=windows-1252; format=flowed
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-28_02:2015-01-28,2015-01-28,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/2015 1:08 PM, Xander Huff wrote:
> From: Josh Cartwright <josh.cartwright@ni.com>
>
> "lockdep: Selftest: Only do hardirq context test for raw spinlock"
> disabled the execution of certain tests with PREEMPT_RT_FULL, but did
> not prevent the tests from still being defined.  This leads to warnings
> like:
>
>    ./linux/lib/locking-selftest.c:574:1: warning: 'irqsafe1_hard_rlock_12' defined but not used [-Wunused-function]
>    ./linux/lib/locking-selftest.c:574:1: warning: 'irqsafe1_hard_rlock_21' defined but not used [-Wunused-function]
>    ./linux/lib/locking-selftest.c:577:1: warning: 'irqsafe1_hard_wlock_12' defined but not used [-Wunused-function]
>    ./linux/lib/locking-selftest.c:577:1: warning: 'irqsafe1_hard_wlock_21' defined but not used [-Wunused-function]
>    ./linux/lib/locking-selftest.c:580:1: warning: 'irqsafe1_soft_spin_12' defined but not used [-Wunused-function]
>    ...
>
> Fixed by wrapping the test definitions in #ifndef CONFIG_PREEMPT_RT_FULL
> conditionals.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Signed-off-by: Xander Huff <xander.huff@ni.com>
> Acked-by: Gratian Crisan <gratian.crisan@ni.com>

FYI: To be clearer, this should apply to all stable RT releases 3.4 and later.

-- 
Xander Huff
Staff Software Engineer
National Instruments
