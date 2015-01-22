Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbbAVT2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:28:07 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49795 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbAVT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:28:05 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86: TLS regression fixes
Date: Thu, 22 Jan 2015 11:27:57 -0800
Message-Id: <cover.1421954363.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent TLS hardening work broke at least one game.  This series
fixes it.  I'm not entirely happy with this series, but I'm far from
entirely happy with the TLS or LDT code in the first place.

Thoughts?

Andy Lutomirski (2):
  x86, tls, ldt: Stop checking lm in LDT_empty
  x86, tls: Interpret an all-zero struct user_desc as "no segment"

 arch/x86/include/asm/desc.h | 20 ++++++++++++++------
 arch/x86/kernel/tls.c       | 25 +++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 8 deletions(-)

-- 
2.1.0

