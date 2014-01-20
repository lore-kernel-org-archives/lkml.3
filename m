Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaATI5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:57:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41882 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaATI5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:57:43 -0500
Message-ID: <52DCE4CF.2060605@zytor.com>
Date: Mon, 20 Jan 2014 00:56:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au> <20140116121955.GQ31570@twins.programming.kicks-ass.net> <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au> <CAJvTdKnoNh2YAvtXraYxTct+8e6e_8Om9cAZGSTpy8UO=t=W4w@mail.gmail.com> <20140120082620.GB30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140120082620.GB30183@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 12:26 AM, Peter Zijlstra wrote:
> On Sun, Jan 19, 2014 at 11:45:43PM -0500, Len Brown wrote:
>> +static void mwait_idle(void)
>> +{
>> +       mwait_idle_with_hints(0, 0);
>> +}
>> +
>>
>> The reason the patch above will crash Core2 machines is because
>> core2 machines don't support mwait_idle_with_hints().
>>
>> The calling sequence for old and new MWAIT instructions is different.
>> The former must be invoked with interrupts enabled,
>> and the later can be invoked with interrupts disabled,
>> which is a feature that Linux takes advantage of.
> 
> What old and new? They're the same byte sequence: 0x0f 0x01 0xc9
> 
> And your 'old' __sti_mwait(0,0) has the exact same arguments as
> mwait_idle_with_hints(0,0).
> 

The difference is the STI!

	-hpa

