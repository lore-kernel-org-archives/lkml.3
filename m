Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbaJaSTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:19:44 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:60007 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703AbaJaSTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:19:42 -0400
MIME-Version: 1.0
In-Reply-To: <5453CE48.406@oracle.com>
References: <5453CE48.406@oracle.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Oct 2014 11:19:20 -0700
Message-ID: <CALCETrWdnJJh_jkCKDOhFOj-MB_FmyEjf-oNdHQ91qd5fcHxHA@mail.gmail.com>
Subject: Re: Commit 258801563b breaks on old compilers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 31, 2014 10:58 AM, "Boris Ostrovsky" <boris.ostrovsky@oracle.com> wrote:
>
> Andy,
>
>
> Your commit 258801563b ("x86/vdso: Change the PER_CPU segment to use struct desc_struct") in -tip breaks old compilers that don't support initialization of anonymous structures (I think pre-4.6):

I bet it breaks clang, too.  Tip people, can you add:

http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-vdso-vmac-fix-build-with-older-gcc.patch

Thanks!

>
> FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap> cat anon.c
> struct bar {
> struct {
> int i;
> };
> };
>
> main()
> {
> struct bar a = {.i = 0};
> }
>
> FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap> gcc --version|head -1
> gcc (GCC) 4.4.4 20100503 (Red Hat 4.4.4-2)
> FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap> gcc anon.c
> anon.c: In function ‘main’:
> anon.c:9: error: unknown field ‘i’ specified in initializer
> FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap>
>
>
> but
>
> build@build-mk2 bootstrap]$ gcc --version|head -1
> gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)
> [build@build-mk2 bootstrap]$ gcc anon.c
> [build@build-mk2 bootstrap]$
>
>
> -boris
