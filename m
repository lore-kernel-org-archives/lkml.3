Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaA0Bu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 20:50:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40612 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaA0Bu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 20:50:57 -0500
Message-ID: <52E5BB66.8060104@zytor.com>
Date: Sun, 26 Jan 2014 17:50:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Ren Qiaowei <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com> <20140126082201.GB28831@gmail.com> <52E4C5F2.8070707@intel.com> <20140126083942.GB29339@gmail.com>
In-Reply-To: <20140126083942.GB29339@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 12:39 AM, Ingo Molnar wrote:
>>
>> It will be only once per startup.
> 
> In that case it would be more efficient to make this part of the 
> binary execution environment so that exec() sets it up automatically, 
> not a separate prctl() syscall.
> 

This is not necessarily possible, and in particular it might need to be
deferred until the MPX runtime has initialized.

What isn't clear to me is if these syscalls are needed at all, or if it
would be better to just let the MPX runtile set BNDSTATUS and BNDCFGU
directly in userspace.  The kernel cannot rely on them staying
consistent across userspace anyway.

Now, it might be beneficial for the kernel to have them anyway.  It's a
bit of a tough call.

	-hpa


