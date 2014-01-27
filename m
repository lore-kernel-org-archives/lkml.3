Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaA0WBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:01:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51142 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbaA0WBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:01:45 -0500
Message-ID: <52E6D72B.1060005@zytor.com>
Date: Mon, 27 Jan 2014 14:01:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Ren Qiaowei <qiaowei.ren@intel.com>,
        Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com> <20140126082201.GB28831@gmail.com> <52E4C5F2.8070707@intel.com> <20140126083942.GB29339@gmail.com> <52E5BB66.8060104@zytor.com> <52E5BC9C.9070400@intel.com> <52E5C000.1050506@zytor.com> <52E6D579.8040505@amacapital.net>
In-Reply-To: <52E6D579.8040505@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 01:54 PM, Andy Lutomirski wrote:
> On 01/26/2014 06:10 PM, H. Peter Anvin wrote:
>> On 01/26/2014 05:55 PM, Ren Qiaowei wrote:
>>>
>>> Peter, you mean we should remove these two call and do what they do in
>>> user-space, right?
>>>
>>
>> Unless we think there is a benefit to the kernel to have a on/off switch
>> for the #BR exception (if disabled, all #BR exceptions are signals,
>> regardless of source.)
> 
> Yes.
> 
> For example, wouldn't UML want to have all of this stuff disabled?
> Presumably it would much prefer to receive the exception directly.
> 
> The same goes for seccomp users -- as it currently stands, this code
> allows mmap without a system call.
> 
> This probably means that the prctl should (optionally) take a parameter
> that fixes the address of the L1 table -- seccomp users would probably
> want that.  (Actually, everyone might -- this is going to have weird
> results if the L1 table moves.)
> 

That seems like a good argument.  If the table has been moved by
userspace we can deliver the signal as a violation.

	-hpa


