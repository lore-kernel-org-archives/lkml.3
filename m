Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaBXRwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:52:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39225 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaBXRwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:52:54 -0500
Message-ID: <530B86CB.3070702@zytor.com>
Date: Mon, 24 Feb 2014 09:52:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140224172536.GD9987@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 09:25 AM, Peter Zijlstra wrote:
>>
>> What is likely happening is the user page fault is triggering 
>> code to do a "perf_callchain" dump, which is calling copy_from_user_nmi()
>> which calls copy_user_generic_string() which is somehow getting the user
>> RBP in the RDI register somehow?
> 
> So that code very much relies on the 'recursive' NMI/iret magic from
> Steve, patch 3f3c8b8c4b2a3 (and assorted fixes later).
> 
> If CR2 is getting corrupted; 7fbb98c5cb075 seems relevant.
> 
> Peter, does x32 have a slightly different ABI/calling convention that
> would make any of these patches just slightly 'off'?
> 

As long as we're talking kernel code, x32 isn't even involved (we do not
support compiling the kernel as x32 and most likely never will.)

	-hpa


