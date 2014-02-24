Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBXRna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:43:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39122 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbaBXRn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:43:29 -0500
Message-ID: <530B8492.2050403@zytor.com>
Date: Mon, 24 Feb 2014 09:42:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241239450.20170@vincent-weaver-1.um.maine.edu>
In-Reply-To: <alpine.DEB.2.10.1402241239450.20170@vincent-weaver-1.um.maine.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 09:41 AM, Vince Weaver wrote:
> On Mon, 24 Feb 2014, Vince Weaver wrote:
> 
>> I do note that 
>> 	perf_callchain_user();
>>
>> Does
>> 	fp = (void __user *)regs->bp;
>> 	
>> 	...
>>
>> 	bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
>>
>>
>> And in my particular executable RBP has nothing to do with a frame 
>> pointer, but is instead being used as a general purpose register.
> 
> and as a reminder, I'm seeing this on an x32 executable, so 
> perf_callchain_user32() is probably coming into play.
> 
> So maybe it is an x32 issue after all.
> 

No.

	if (!test_thread_flag(TIF_IA32))
		return 0;

TIF_IA32 is clear for an x32 process.

	-hpa

