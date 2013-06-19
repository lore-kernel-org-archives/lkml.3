Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3FSToe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:44:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:62819 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3FSTod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:44:33 -0400
Message-ID: <51C20A1E.4070609@tilera.com>
Date: Wed, 19 Jun 2013 15:44:30 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile bug fix for v3.10
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following change for 3.10 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

This change allows the older tilepro architecture to be correctly
built by newer gccs, despite a change that caused gcc to start
trying to use an out-of-line implementation for __builtin_ffsll().
This should be inline again starting with gcc 4.7.4 and 4.8.2 or so,
but meanwhile this change keeps things from breaking, with the only
cost being a few bytes of code in the kernel to provide __ffsdi2
even for compilers that do inline it.

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7

 arch/tile/lib/exports.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

