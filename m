Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaFMFjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:39:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43663 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaFMFjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:39:47 -0400
Message-ID: <539A8E89.5000602@zytor.com>
Date: Thu, 12 Jun 2014 22:39:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Russ Cox <rsc@golang.org>,
        Ian Taylor <iant@golang.org>
Subject: Re: vdso feature requests from the Go people
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com> <539A890A.5090206@zytor.com> <CALCETrX9Og2LR3d8HZrcn4uGAgLfxbv51LK4Tsq-gDZKGpsjYw@mail.gmail.com>
In-Reply-To: <CALCETrX9Og2LR3d8HZrcn4uGAgLfxbv51LK4Tsq-gDZKGpsjYw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 10:23 PM, Andy Lutomirski wrote:
> 
> As far as I know, there's no reliable way to just read the dynsym
> table -- the thing doesn't have a specified length, which is what
> broke Go in the first place.
> 

Ah yes, you're right.

>
> Parsing the ELF dynamic tables is kind of annoyingly complicated, and
> understanding the format is a real PITA -- the documentation I've been
> able to find is outright terrible.
> 

Yes... not entirely clear that putting it in the vdso is a net win,
though.  There are some people who would like to put a significant chunk
of libc in the vdso, and it just doesn't seem like a good idea.

An index table is somewhat more reasonable, but (a) not backwards
compatible (so wouldn't work with older kernels) and (b) has shades of
Windows...

	-hpa


