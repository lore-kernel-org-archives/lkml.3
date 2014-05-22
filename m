Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaEVX6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:58:31 -0400
Received: from mx10.pku.edu.cn ([162.105.129.173]:39024 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751247AbaEVX63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:58:29 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.489
Date: Fri, 23 May 2014 07:58:11 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: David Miller <davem@davemloft.net>
Cc: gang chen 5i5j <gang.chen.5i5j@gmail.com>, gerrit@erg.abdn.ac.uk,
        gxt@mprc.pku.edu.cn, dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <263613432.57393.1400803091663.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20140522.153313.958087444510569794.davem@davemloft.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_[PATCH_linux-nex?=
 =?utf-8?Q?t]_net/dccp/timer.c:_use_?=
 =?utf-8?Q?'u64'_instead_of_'s64'_to_avoid_compiler's_warning?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- David Miller <davem@davemloft.net> 写道：
> From: Chen Gang <gang.chen.5i5j@gmail.com>
> Date: Wed, 21 May 2014 08:19:34 +0800
> 
> > 'dccp_timestamp_seed' is initialized once by ktime_get_real() in
> > dccp_timestamping_init(). It is always less than ktime_get_real()
> > in dccp_timestamp().
> > 
> > Then, ktime_us_delta() in dccp_timestamp() will always return positive
> > number. So can use manual type cast to let compiler and do_div() know
> > about it to avoid warning.
> > 
> > The related warning (with allmodconfig under unicore32):
> > 
> >     CC [M]  net/dccp/timer.o
> >   net/dccp/timer.c: In function ‘dccp_timestamp’:
> >   net/dccp/timer.c:285: warning: comparison of distinct pointer types lacks a cast
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Applied to net-next, thanks.
> 
> But that type check in include/asm-generic/div64.h is bogus, it should
> be checking sizeof(X) == 8 rather than the type thing, it just wants to
> make sure that the value is 64-bit regardless of it's signedness.
> 
> The arch local implementations do not do this, and that's why very few
> other people notice this warning.

Arch-dependent codes implement it with unsigned long long type.
And, every warning should not be ignored.
