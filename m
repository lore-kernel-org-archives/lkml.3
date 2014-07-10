Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaGJKme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:42:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38588 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaGJKmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:42:32 -0400
Date: Thu, 10 Jul 2014 12:42:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: linux-kbuild@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Sam Ravnborg <sam@ravnborg.org>,
        lkml <linux-kernel@vger.kernel.org>, Michael Matz <matz@suse.de>,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH] Kbuild: Move -Wmaybe-uninitialized to W=1
Message-ID: <20140710104223.GD2970@pd.tnic>
References: <20140616132045.GE8170@pd.tnic>
 <20140616211405.GA7914@ravnborg.org>
 <20140624213835.GD15068@pd.tnic>
 <20140707105339.GA4776@pd.tnic>
 <1404811520.26126.38.camel@x220>
 <20140708113724.GA27659@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140708113724.GA27659@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And,

I haven't even wished for it but just to prove everybody my point: just
built rc4+ from Linus' repo with gcc 4.9.0, see below.

Now all of a sudden there's more noise, maybe because this is a
different .config. However, I doubt those are real bugs.

A cursory look through those shows that they're not really bugs -
gcc simply can't know with all the ifdeffery, partial usage based on
conditionals, etc, etc.

---
In file included from scripts/sortextable.c:194:0:
scripts/sortextable.c: In function ‘main’:
scripts/sortextable.h:176:3: warning: ‘relocs_size’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   memset(relocs, 0, relocs_size);
   ^
scripts/sortextable.h:106:6: note: ‘relocs_size’ was declared here
  int relocs_size;
      ^
In file included from scripts/sortextable.c:192:0:
scripts/sortextable.h:176:3: warning: ‘relocs_size’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   memset(relocs, 0, relocs_size);
   ^
scripts/sortextable.h:106:6: note: ‘relocs_size’ was declared here
  int relocs_size;
      ^
fs/namespace.c: In function ‘SyS_mount’:
fs/namespace.c:2647:8: warning: ‘kernel_dev’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2626:8: note: ‘kernel_dev’ was declared here
  char *kernel_dev;
        ^
fs/namespace.c:2647:8: warning: ‘kernel_type’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
        ^
fs/namespace.c:2624:8: note: ‘kernel_type’ was declared here
  char *kernel_type;
        ^
fs/direct-io.c: In function ‘do_blockdev_direct_IO’:
fs/direct-io.c:920:9: warning: ‘to’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   while (from < to) {
         ^
fs/direct-io.c:913:16: note: ‘to’ was declared here
   size_t from, to;
                ^
fs/direct-io.c:1034:9: warning: ‘from’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    from += this_chunk_bytes;
         ^
fs/direct-io.c:913:10: note: ‘from’ was declared here
   size_t from, to;
          ^
In file included from include/net/inetpeer.h:15:0,
                 from net/ipv4/tcp_metrics.c:16:
net/ipv4/tcp_metrics.c: In function ‘tcp_peer_is_proven’:
include/net/ipv6.h:422:38: warning: ‘*((void *)&daddr+8)’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  return ((ul1[0] ^ ul2[0]) | (ul1[1] ^ ul2[1])) == 0UL;
                                      ^
net/ipv4/tcp_metrics.c:231:30: note: ‘*((void *)&daddr+8)’ was declared here
  struct inetpeer_addr saddr, daddr;
                              ^
In file included from include/net/inetpeer.h:15:0,
                 from net/ipv4/tcp_metrics.c:16:
include/net/ipv6.h:422:38: warning: ‘*((void *)&saddr+8)’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  return ((ul1[0] ^ ul2[0]) | (ul1[1] ^ ul2[1])) == 0UL;
                                      ^
net/ipv4/tcp_metrics.c:231:23: note: ‘*((void *)&saddr+8)’ was declared here
  struct inetpeer_addr saddr, daddr;
                       ^

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
