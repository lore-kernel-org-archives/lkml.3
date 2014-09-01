Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaIAAvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:51:12 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44923 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaIAAvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <1409511586.1483.5.camel@haakon3.risingtidesystems.com>
References: <1409511586.1483.5.camel@haakon3.risingtidesystems.com>
Date: Sun, 31 Aug 2014 17:51:07 -0700
X-Google-Sender-Auth: p3Bch2O3loxDAcoZTCgFqFrSoJo
Message-ID: <CA+55aFx6_pbUwuyhYYSu+=eAA+7o0LDu251Bo7T2ZYo9vZc1kg@mail.gmail.com>
Subject: Re: [GIT PULL] target updates for v3.17-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 11:59 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> Note that these patches where originally intended for -rc1, but missed
> the merge window.  They are mostly iser-target related bug-fixes, along
> with a few other very minor cleanups.

So this pull request was strictly speaking too late for rc3, but I
went "what the hell, it's small" and pulled it anyway.

And then I get this:

  drivers/target/target_core_transport.c: In function
‘transport_dump_vpd_ident_type’:
  drivers/target/target_core_transport.c:956:3: warning: passing
argument 1 of ‘strlen’ makes pointer from integer without a cast
[enabled by default]
     len = strlen(len);
     ^
  In file included from include/linux/bitmap.h:8:0,
                   from include/linux/cpumask.h:11,
                   from ./arch/x86/include/asm/cpumask.h:4,
                   from ./arch/x86/include/asm/msr.h:10,
                   from ./arch/x86/include/asm/processor.h:20,
                   from ./arch/x86/include/asm/archrandom.h:26,
                   from include/linux/random.h:81,
                   from include/linux/net.h:22,
                   from drivers/target/target_core_transport.c:26:
  include/linux/string.h:80:24: note: expected ‘const char *’ but
argument is of type ‘int’
   extern __kernel_size_t strlen(const char *);
                          ^

and I just go "Yeah, that broken crap can wait until 3.18 after all".

So it got unpulled.

That "strlen(len)" should clearly be a "strlen(buf)" in that commit
6cfa853ceee4, but equally clearly this pull request was pure and utter
garbage, and that "cleanup" commit was shit that nobody had ever even
bothered to compile.

Thanks, but no. And please never send this kind of untested crap to me again,

                   Linus
