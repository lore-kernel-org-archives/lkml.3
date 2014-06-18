Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaFRU6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:58:31 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:53901 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaFRU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:58:29 -0400
From: Paul Moore <paul@paul-moore.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gideon Israel Dsouza <gidisrael@gmail.com>, sds@tycho.nsa.gov,
        Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] security: Used macros from compiler.h instead of __attribute__((...))
Date: Wed, 18 Jun 2014 16:58:25 -0400
Message-ID: <1772413.506pXYt1XL@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.5-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <CAMuHMdVJ7zv0qqhZNMNXihm4Kqv9WA9yyMe3F9ptUZyDjvEnTg@mail.gmail.com>
References: <1402502130-26400-1-git-send-email-gidisrael@gmail.com> <3604441.fZpjWNppGq@sifl> <CAMuHMdVJ7zv0qqhZNMNXihm4Kqv9WA9yyMe3F9ptUZyDjvEnTg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 18, 2014 10:08:13 PM Geert Uytterhoeven wrote:
> On Wed, Jun 18, 2014 at 8:50 PM, Paul Moore <paul@paul-moore.com> wrote:
> > On Wednesday, June 11, 2014 09:25:30 PM Gideon Israel Dsouza wrote:
> >> To increase compiler portability there is <linux/compiler.h> which
> >> provides convenience macros for various gcc constructs.  Eg: __packed
> >> for __attribute__((packed)).
> >> 
> >> This patch is part of a large task I've taken to clean the gcc
> >> specific attributes and use the the macros instead.
> >> 
> >> Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
> >> ---
> >> 
> >>  security/selinux/include/security.h | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > From what I can tell this should still work with both the LLVM and Intel
> > compilers, is that correct?
> 
> That's the idea of the compiler-agnostic attribute macros.

I just wanted to make sure as I personally only really use gcc and don't 
pretend to be up on all the details regarding other compilers.

> Interestingly, only include/linux/compiler-gcc.h defines __packed.

>From what I could tell by looking at the code, the other compilers all define 
__GNUC__ so they get the __packed macro as part of the gcc configuration.  I 
believe the LLVM and Intel compilers would only need to redefine __packed if 
they wanted/needed a different definition.

> As it's already in heavy use, I can only assume both LLVM and the Intel
> compilers handle both "__packed" (without a special definition) and the
> gcc-specific "__attribute__((packed))".

Yep, seems reasonable.  I'll go ahead and apply the patch.

-- 
paul moore
www.paul-moore.com

