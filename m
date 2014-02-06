Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbaBFQxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:53:08 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33825 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbaBFQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140206135001.333583247@infradead.org>
References: <20140206134825.305510953@infradead.org>
	<20140206135001.333583247@infradead.org>
Date: Thu, 6 Feb 2014 08:53:02 -0800
X-Google-Sender-Auth: _uVOhh3kIHGguPtpSM8b5SDUby0
Message-ID: <CA+55aFwzn09dPJekgCbO2VRO8j3=eEt2j_QFd=Gd4MXTA2gm9g@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] arch: Sanitize atomic_t bitwise ops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 5:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Many archs have atomic_{set,clear}_mask() but not all. Remove these
> and provide a comprehensive set of bitops:
>
>   atomic{,64}_{and,or,xor}{,_return}()

Who uses these, and why?

The "_return()" versions of atomic ops are noticeably slower and more
complex on common architectures (ie x86), and apparently there is no
use of them since they didn't exist.

So why add them? Just to encourage people to do bad things?

                  Linus
