Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaFMFkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:40:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43686 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaFMFkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:40:02 -0400
Message-ID: <539A8EA8.9080901@zytor.com>
Date: Thu, 12 Jun 2014 22:39:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Russ Cox <rsc@golang.org>,
        Ian Taylor <iant@golang.org>
Subject: Re: vdso feature requests from the Go people
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
In-Reply-To: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 09:36 PM, Andy Lutomirski wrote:
> 
> 1. Parsing the vDSO is a PITA.  What if we bundled the reference
> parser inside the vdso?  Concretely, we could have AT_VDSO_FINDENTRY
> point to a function like:
> 
> void *vdso_find_entry(const char *name, const char *version)
> 
> Then things like Go and maybe even musl (and klibc?) could just call
> that function.  And we'd never have to worry about maintaining
> compatibility with more and more weird vdso parsers.
> 
> Implementing this could be as simple as shoving parse_vdso.c into the
> vdso, although vdso2c could help and allow a really simple in-vdso
> implementation.
> 

I'm not really sure how much of a win that is... you have to parse
*something*, and for the vast majority of all implementations there will
be a dynamic linker just sitting there, and that is what it *does*.

> 2. Go uses a segmented stack, and the vdso is quite unfriendly for
> segmented stack.  If we can get compiler support, is there a
> reasonable way that we could advertise the maximum stack usage of each
> vdso entry point?

I suspect an easier way to do that would just be to define a maximum
stack usage for *any* vdso entry point, and then enable the gcc stack
depth warning (perhaps even with Werror)... we can do this now.

	-hpa

