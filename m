Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3DWE7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:59:55 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41797 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3DWE7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:59:54 -0400
Message-ID: <51761604.6080103@linux.vnet.ibm.com>
Date: Tue, 23 Apr 2013 10:33:00 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop> <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop> <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop> <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com> <5175A277.5080208@redhat.com> <1366664518.8337.21.camel@laptop>
In-Reply-To: <1366664518.8337.21.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042304-5140-0000-0000-00000313EB91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 02:31 AM, Peter Zijlstra wrote:
> On Mon, 2013-04-22 at 16:49 -0400, Rik van Riel wrote:
>> Given the fairly high cost of rescheduling a VCPU (which is likely
>> to include an IPI), versus the short hold time of most spinlocks,
>> I have the strong suspicion that your approach would win.
>
>    https://lkml.org/lkml/2012/5/2/101
>
> If you schedule too often your SPIN_THRESHOLD is far too low.
>
> Anyway.. performance can't be that bad, otherwise Jeremey would have
> spend as much time on it as he did.

When I experimented last time ideal SPIN_THRESHOLD for PLE machine,
was around 4k, 8k. Jeremy's experiment was on a non-PLE machine AFAIK,
which complemented PLE feature in a nice way with 2k threshold.

