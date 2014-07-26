Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaGZTgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:36:09 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:51002 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbaGZTgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:36:05 -0400
Date: Sat, 26 Jul 2014 21:35:57 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140726193557.GA21842@x4>
References: <20140723190230.GH3935@laptop>
 <CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
 <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
 <53D1B1EF.7030603@daenzer.net>
 <20140725035527.GA30108@pg-vmw-gw1>
 <20140725140237.GB32669@home.goodmis.org>
 <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.07.26 at 11:39 -0700, Linus Torvalds wrote:
> On Sat, Jul 26, 2014 at 11:28 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That's a bit worrisome. I haven't actually checked if the code
> > generation differs in significant ways yet..
> 
> Nope. Just three instructions that got re-ordered from ABC to CAB in a
> way that makes no difference. But just the knowledge that "-g" affects
> code generation is nasty.  And with "allmodconfig" my build fails
> almost immediately (failures on at least arch/x86/kernel/process_64.c,
> kernel/exit.c and mm/vmalloc.c in that case. I was too lazy to check
> what the differences were).
> 
> Does anybody have current gcc build and can verify that current gcc
> tip passes the kernel compile with that
> 
>     export GCC_COMPARE_DEBUG=1
> 
> thing?

The fs/ext4/inode.c issue is a variant of the gcc bug and isn't fixed
yet. I will open a bug report. The kernel/exit.c issue is already fixed,
see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61801 for a reduced
testcase. 

But fortunately the workaround for the new inode.c bug is the same as
for the original bug: -fno-var-tracking-assignments. 

It would make sense to enabled it unconditionally for all debug
configurations for now.

-- 
Markus
