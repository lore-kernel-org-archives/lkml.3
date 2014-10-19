Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaJSXwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:52:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18536 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaJSXwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:52:21 -0400
Message-ID: <54444EB1.5010301@oracle.com>
Date: Sun, 19 Oct 2014 19:52:17 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com> <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
In-Reply-To: <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 04:05 PM, Linus Torvalds wrote:
> On Sun, Oct 19, 2014 at 9:07 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> > gcc5 changes the default standard to c11, rather than gnu89, which
>> > makes kernel build unhappy.
> Hmm. Just how unhappy does it make it? Maybe we can instead try to
> make the build happier with some minimal changes? Or is it really
> painful?

The build breakage is easy to fix. I'm worried about the stuff that won't show
upon build. Different behaviours that go unnoticed and maybe issues inside
gcc's code generation that weren't uncovered until now.

Also, unless we specify exactly what standard we want what would happen is that
a significantly different C standard would be used depending on the compiler
version. It is already the case with clang but putting in a 3rd one in the
mix is too much IMO.

I'll send a few other patches to make it at least compile under c11, but I still
think that we should plug this hole by sticking with gnu89 for now.

Thanks,
Sasha
