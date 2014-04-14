Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaDNPu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:50:29 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36148 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaDNPu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:50:27 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Theodore Ts'o" <tytso@mit.edu>, Greg Price <price@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH resend 0/2] random: Use DRBG sources
Date: Mon, 14 Apr 2014 08:49:58 -0700
Message-Id: <cover.1397487345.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resent because I forgot to email lkml.  This also surreptitiously
 fixes a silly typo on a patch description.]

This is my attempt to come up with a workable way to use so-called
entropy sources like a TPM to feed /dev/urandom.

Arguably we should be feeding the input pool as well, but if the
/dev/random algorithm is correct, this shouldn't matter.  I don't want
sensible use of TPMs for /dev/urandom to block on a long debate about
/dev/random, so these patches have no effect on /dev/random.

Andy Lutomirski (2):
  random: Add add_drbg_randomness to safely seed urandom from crypto hw
  tpm,random: Call add_drbg_randomness after selftest

 drivers/char/random.c            | 56 +++++++++++++++++++++++++++++++++++-----
 drivers/char/tpm/tpm-interface.c | 15 ++++++++++-
 include/linux/random.h           |  1 +
 include/trace/events/random.h    | 19 ++++++++++++++
 4 files changed, 83 insertions(+), 8 deletions(-)

-- 
1.9.0

