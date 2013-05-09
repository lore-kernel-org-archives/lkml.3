Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3EIESX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:18:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47282 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab3EIESW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:18:22 -0400
Message-ID: <518B2387.9030408@zytor.com>
Date: Wed, 08 May 2013 21:18:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
References: <1368072057-7832-1-git-send-email-vapier@gentoo.org> <518B2033.80300@zytor.com> <201305090008.47432.vapier@gentoo.org>
In-Reply-To: <201305090008.47432.vapier@gentoo.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:08 PM, Mike Frysinger wrote:
> On Thursday 09 May 2013 00:04:03 H. Peter Anvin wrote:
>> On 05/08/2013 09:00 PM, Mike Frysinger wrote:
>>> When including these headers in the x32 ABI, the structs get
>>> declared with 32bit sizes which is incorrect.  Use long long
>>> and such to make it work both with x32 and x86_64.
>> 
>> I'm not sure if it is okay to change the types, even within the
>> same size.  Perhaps use __u64/__s64?
> 
> sorry, i don't follow.  changing types isn't ok (unsigned long to
> unsigned long long), but changing to __u64 is ok (unsigned long to
> __u64 which is typedefed to unsigned long long) ?
> 
> i don't have a problem using __u64/__s64, i just don't understand
> your logic.
> 

In userspace, __u64 is often defined as "unsigned long" on 64 bits.

	-hpa

