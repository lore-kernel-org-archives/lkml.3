Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab3LLPIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:08:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48812 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3LLPH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:07:59 -0500
Message-ID: <52A9D111.3090409@zytor.com>
Date: Thu, 12 Dec 2013 07:06:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
References: <20131211113839.GF21683@pd.tnic> <20131211115239.GA21999@twins.programming.kicks-ass.net> <1386764955.12005.60.camel@marge.simpson.net> <20131211124352.GB21999@twins.programming.kicks-ass.net> <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com> <20131211164318.GA2480@laptop.programming.kicks-ass.net> <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com> <20131212085143.GC21999@twins.programming.kicks-ass.net> <20131212132846.GA16750@gmail.com>
In-Reply-To: <20131212132846.GA16750@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 05:28 AM, Ingo Molnar wrote:
>>
>> The reason we use thread_info::flags is because we need to write
>> TIF_NEED_RESCHED into it to wake up anyhow.
>>
>> Using another cacheline would mean the wakeup path would need to write a
>> second cross cpu cacheline -- that is badness too.
>>
>> So no, I don't think we want to listen to another line.
> 

Right, okay, so that's the implicit wakeup.  However, I would think the
CLFLUSH would hurt a lot more.

	-hpa


