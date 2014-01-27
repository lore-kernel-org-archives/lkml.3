Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaA0CCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 21:02:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:5070 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaA0CCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 21:02:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,726,1384329600"; 
   d="scan'208";a="444962728"
Message-ID: <52E5BCD5.8090408@intel.com>
Date: Mon, 27 Jan 2014 09:56:37 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include
 bound violation information
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.02.1401252010400.10325@chino.kir.corp.google.com> <52E4919B.8050408@intel.com> <alpine.DEB.2.02.1401261335400.26515@chino.kir.corp.google.com> <52E5B7AA.9060205@intel.com> <52E5BC03.3080207@zytor.com>
In-Reply-To: <52E5BC03.3080207@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 09:53 AM, H. Peter Anvin wrote:
> On 01/26/2014 05:34 PM, Ren Qiaowei wrote:
>>>
>> I agree with you and we should suppress all the warnings as possible. If
>> I use (unsgined long) to cast like the following code, what do you think
>> about it? sizeof(long) will be 4 for 32-bit.
>>
>>      info->si_lower = (void __user *)(unsigned long)
>>          (xsave_buf->bndregs.bndregs[2*bndregno]);
>>      info->si_upper = (void __user *)(unsigned long)
>>      (~xsave_buf->bndregs.bndregs[2*bndregno+1]);
>>
>
> That is the way it is usually done, yes.  Add a comment saying something
> like:
>
> 	/* Note: the upper 32 bits are ignored in 32-bit mode. */
>
> It is worth watching out a bit here, though, because you could be
> running a 32-bit process on top of a 64-bit kernel.
>
Ok. I will update it in next version.

Thanks,
Qiaowei
