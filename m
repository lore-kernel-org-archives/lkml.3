Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3LHE5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 23:57:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab3LHE5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 23:57:11 -0500
Message-ID: <1386478624.4748.19.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Sun, 08 Dec 2013 05:57:04 +0100
In-Reply-To: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:p9jmdkrWdQ5U5hLYYd2C35S1+dDoCEpfsDSZOOXLgyu
 rDaXooXrIhQiVwTEjAeE6wcQnZFihFgQEhYat+WDEsbZ3fAe0K
 FPME52mxQtAfSXeL+vCiZ+xZFKoEb6HiIiperp5TGdqsHRXHSz
 8SHbKpKxU9+w3x5vE4RkOyGda+1eR15Uhmsq+byd49GMPwjuZR
 b1icLSQ20hbKFFhMu3MEFH2iUvYCZJUOgAIbkyeGIjFfP0uDUf
 OXQly9pfI//vFOY3E5s+jlFKV+Khw/PfIZFt785X6GgRvnZleD
 kLFyQRMEL+XCQo5DQpnIygU3SCOQpwMFhjHASokXGVNU7EGsm1
 ZT2m7VmcVfrJls8jUW5g/5y1mNBWsbvgpn6c43dy0hh3jLzORu
 B6EYpzwJ4af5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-07 at 03:00 -0500, Len Brown wrote: 
> Hello Thomas,
> 
> An idle WSM-EX box (40 Xeon cores) runs 50 Watts hotter after this patch:
> 
> commit 7d1a941731fabf27e5fb6edbebb79fe856edb4e5
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Mar 21 22:50:03 2013 +0100
> 
>     x86: Use generic idle loop
> 
> ie. the commit before this patch (aba92c9e2cf3042bf6efc68fa2e4235ba01bf499)
> runs at 50 watts less, as do Linux 3.7, 3.8 and 3.9.
> 
> The difference is that the good kernels allow about 98% residence
> in the package C6 state, while the bad kernel is so noisy that it
> gets into pc6 0% of the time.
> (indeed, even core C6 is reduced to about 50% from over 99%)

FWIW, my little x3550 (E5620) box is spending ~99% of its time in C3 per
powertop, deepest state it has.  It took a big hit from 69a37bea as well
as 7d1a9417, but with revert of 69a37bea, and addition of ea811747, it's
fairly close to 3.7 in fastpath weight, and greenery _seems_ fine.

-Mike

