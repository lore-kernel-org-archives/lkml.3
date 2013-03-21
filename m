Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab3CUOc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:32:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58812 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933533Ab3CUOc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:32:56 -0400
Message-ID: <514B1981.2080107@zytor.com>
Date: Thu, 21 Mar 2013 07:30:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        penguin-kernel@I-love.SAKURA.ne.jp,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address
 by __pa_nodebug()
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com> <20130321104018.GA18484@gmail.com>
In-Reply-To: <20130321104018.GA18484@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 03:40 AM, Ingo Molnar wrote:
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
>> +	initrd_start_p = (unsigned long *)__pa_nodebug(&initrd_start);
>> +	initrd_start_addr = (unsigned long)__pa_nodebug(*initrd_start_p);
> 
> We should probably use __pa_early() for that - aliased to __pa_nodebug(). 
> That would self-document the purpose.
> 

Well, it's not that it is early, it is that it actually can execute in
linear mode (paging off).

	-hpa


