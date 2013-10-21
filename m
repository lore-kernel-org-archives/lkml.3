Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3JUInP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:43:15 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42349 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3JUInO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 21 Oct 2013 04:43:14 -0400
Message-Id: <5265053C02000078000FC4E8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 21 Oct 2013 09:43:08 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arjan@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] x86: unify / improve copy_*_user()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first of these patches unifies copy_from_user(), thus making its
buffer size checking consistent between 32- and 64-bit.

The second one unifies copy_to_user(), at once adding similar
buffer size checking (to help avoiding information leaks).

1: x86: unify copy_from_user() size checking
2: x86: unify copy_to_user() and add size checking to it

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>

 include/asm/uaccess.h    |   98 +++++++++++++++++++++++++++++++++++++++++++++++
 include/asm/uaccess_32.h |   29 -------------
 include/asm/uaccess_64.h |   28 -------------
 lib/usercopy_32.c        |    8 +--
 4 files changed, 101 insertions(+), 62 deletions(-)


