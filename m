Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaK2PHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 10:07:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21988 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaK2PHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 10:07:16 -0500
Message-ID: <5479E11C.8080701@oracle.com>
Date: Sat, 29 Nov 2014 10:07:08 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/2] compiler: use compiler to detect integer overflows
References: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>	<CA+55aFwjTTcGFbbEPWckxZHya5PFWo+MFbK9zMzoqZorXV21nQ@mail.gmail.com>	<54768059.1080406@oracle.com> <CA+55aFxx+Ye+v6bkK0TwzkAHxSEUc7e-EAW-1JD8mySE2nVq2w@mail.gmail.com>
In-Reply-To: <CA+55aFxx+Ye+v6bkK0TwzkAHxSEUc7e-EAW-1JD8mySE2nVq2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 10:13 PM, Linus Torvalds wrote:
> .. which I didn't actually validate. And I suspect gcc won't be good
> enough to optimize, so it probably generates horrendous code.

That's correct. It's pretty bad.

> And the thing is, I think it's just *wrong* to do "overflow in signed
> type". The code that does it shouldn't be helped to do it, it should
> be fixed to use an unsigned type.
> 
> In other words - in this case, the lofft_t should probably just be a u64.

In this case it's very tied to userspace. One caller is the space allocation
ioctl, which gets this from userspace:

struct space_resv {
	[...]
        __s64           l_start;
        __s64           l_len;          /* len == 0 means until end of file */
        [...]
};

Since we can't just change those to unsigned, we'd still need to do an overflow
check with signed integers somewhere.


Thanks,
Sasha
