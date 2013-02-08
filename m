Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab3BHOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:25:59 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38122 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab3BHOZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:25:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>, benh@kernel.crashing.org,
        mahesh@linux.vnet.ibm.com, zhangyanfei@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
References: <510E6280.3070203@gmail.com>
	<20130207160620.6c8f93d4.akpm@linux-foundation.org>
Date: Fri, 08 Feb 2013 06:25:39 -0800
In-Reply-To: <20130207160620.6c8f93d4.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 7 Feb 2013 16:06:20 -0800")
Message-ID: <87ehgq3msc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19TdWp87eMkT2vdDvmVy1yz7Kc1ifFWJTI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fs/proc/vmcore.c: Put if tests in the top of the while loop to reduce duplication
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 03 Feb 2013 21:13:36 +0800
> Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
>
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> 
>> In function read_vmcore, two if tests are duplicate. Change the position
>> of them could reduce the duplication. This change does not affect
>> the behaviour of the function.

> While we're there, let's squish that assignment-in-a-if pestilence and
> use max_t().

min_t please.  Or do you mean to change the behavior of the code?

> --- a/fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix
> +++ a/fs/proc/vmcore.c
> @@ -178,8 +178,7 @@ static ssize_t read_vmcore(struct file *
>          	return -EINVAL;
>  
>  	while (buflen) {
> -		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
> -			tsz = buflen;
> +		tsz = max_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
>  
>  		/* Calculate left bytes in current memory segment. */
>  		nr_bytes = (curr_m->size - (start - curr_m->paddr));
> _
