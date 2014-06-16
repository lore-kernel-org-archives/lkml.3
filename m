Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaFPNU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:20:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47006 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaFPNUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:20:55 -0400
Date: Mon, 16 Jun 2014 15:20:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Michael Matz <matz@suse.de>, linux-kbuild@vger.kernel.org,
        x86-ml <x86@kernel.org>
Subject: [RFC] Turn off -Wmaybe-uninitialized completely and move it to W=1
Message-ID: <20140616132045.GE8170@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so 3.16-rc1 adds this false positive from gcc, see below (triggers on
4.9 and 4.8.2). Now, it is firing wrong and gcc people tell me there's
no way for the compiler to know that the "from" and "to" values will NOT
be used in the error case, i.e. thus the "maybe" aspect.

So, we've disabled it for -Os already:

	e74fc973b6e5 ("Turn off -Wmaybe-uninitialized when building with -Os")

maybe we want to disable it by default on all and move it to W=1. This
way people can still have it fire but not by default. And from what I've
seen so far, it is mostly firing wrong and it is becoming annoying.

So what do people think, any reasons for keeping it enabled by default?

Thanks.

---

fs/direct-io.c: In function ‘__blockdev_direct_IO’:
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


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
