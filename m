Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3DPHuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:50:55 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:52218 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3DPHux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:50:53 -0400
Date: Tue, 16 Apr 2013 09:50:47 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Zhouping Liu <zliu@redhat.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        caiqian <caiqian@redhat.com>, Caspar Zhang <czhang@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG][s390x] mm: system crashed
Message-ID: <20130416075047.GA4184@osiris>
References: <156480624.266924.1365995933797.JavaMail.root@redhat.com>
 <2068164110.268217.1365996520440.JavaMail.root@redhat.com>
 <20130415055627.GB4207@osiris>
 <516B9B57.6050308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <516B9B57.6050308@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041607-3548-0000-0000-0000051B72E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 02:16:55PM +0800, Zhouping Liu wrote:
> On 04/15/2013 01:56 PM, Heiko Carstens wrote:
> >On Sun, Apr 14, 2013 at 11:28:40PM -0400, Zhouping Liu wrote:
> >>� 16109.346170¨ Call Trace:
> >>� 16109.346179¨ (� <0000000000100920>¨ show_trace+0x128/0x12c)
> >>� 16109.346195¨  � <00000000001cd320>¨ rcu_check_callbacks+0x458/0xccc
> >>� 16109.346209¨  � <0000000000140f2e>¨ update_process_times+0x4a/0x74
> >>� 16109.346222¨  � <0000000000199452>¨ tick_sched_handle.isra.12+0x5e/0x70
> >>� 16109.346235¨  � <00000000001995aa>¨ tick_sched_timer+0x6a/0x98
> >>� 16109.346247¨  � <000000000015c1ea>¨ __run_hrtimer+0x8e/0x200
> >>� 16109.346381¨  � <000000000015d1b2>¨ hrtimer_interrupt+0x212/0x2b0
> >>� 16109.346385¨  � <00000000001040f6>¨ clock_comparator_work+0x4a/0x54
> >>� 16109.346390¨  � <000000000010d658>¨ do_extint+0x158/0x15c
> >>� 16109.346396¨  � <000000000062aa24>¨ ext_skip+0x38/0x3c
> >>� 16109.346404¨  � <00000000001153c8>¨ smp_yield_cpu+0x44/0x48
> >>� 16109.346412¨ (� <000003d10051aec0>¨ 0x3d10051aec0)
> >>� 16109.346457¨  � <000000000024206a>¨ __page_check_address+0x16a/0x170
> >>� 16109.346466¨  � <00000000002423a2>¨ page_referenced_one+0x3e/0xa0
> >>� 16109.346501¨  � <000000000024427c>¨ page_referenced+0x32c/0x41c
> >>� 16109.346510¨  � <000000000021b1dc>¨ shrink_page_list+0x380/0xb9c
> >>� 16109.346521¨  � <000000000021c0a6>¨ shrink_inactive_list+0x1c6/0x56c
> >>� 16109.346532¨  � <000000000021c69e>¨ shrink_lruvec+0x252/0x56c
> >>� 16109.346542¨  � <000000000021ca44>¨ shrink_zone+0x8c/0x1bc
> >>� 16109.346553¨  � <000000000021d080>¨ balance_pgdat+0x50c/0x658
> >>� 16109.346564¨  � <000000000021d318>¨ kswapd+0x14c/0x470
> >>� 16109.346576¨  � <0000000000158292>¨ kthread+0xda/0xe4
> >>� 16109.346656¨  � <000000000062a5de>¨ kernel_thread_starter+0x6/0xc
> >>� 16109.346682¨  � <000000000062a5d8>¨ kernel_thread_starter+0x0/0xc
> >>[-- MARK -- Fri Apr 12 06:15:00 2013]
> >>� 16289.386061¨ INFO: rcu_sched self-detected stall on CPU { 0}  (t=42010 jiffies
> >>  g=89766 c=89765 q=10627)
> >Did the system really crash or did you just see the rcu related warning(s)?
> 
> I just check it again, actually at first the system didn't really
> crash, but the system is very slow in response.
> and the reproducer process can't be killed, after I did some common
> actions such as 'ls' 'vim' etc, the system
> seemed to be really crashed, no any response.
> 
> also in the previous testing, I can remember that the system would
> be no any response for a long time, just only
> repeatedly print out the such above 'Call Trace' into console.

Ok, thanks.
Just a couple of more questions: did you see this also on other archs, or just
s390 (if you tried other platforms at all).

If you have some time, could you please repeat your test with the kernel
command line option " user_mode=home "?

As far as I can tell there was only one s390 patch merged that was
mmap related: 486c0a0bc80d370471b21662bf03f04fbb37cdc6 "s390/mm: Fix crst
upgrade of mmap with MAP_FIXED".
Even though I don't think it explains the bug you've seen it might be worth
to try to revert it.

And at last, can you share your kernel config?

Thanks,
Heiko

