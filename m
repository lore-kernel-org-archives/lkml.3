Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632Ab3DYVzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:55:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41876 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759598Ab3DYVzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:55:18 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 0/6] kernel ASLR
Date: Thu, 25 Apr 2013 14:54:14 -0700
Message-Id: <1366926860-26776-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This continues to build on the tip/kaslr patches for KASLR. This series
converts the logic to C, and moves both relocation and address selection
into the decompress_kernel path. Several areas were refactored to allow
for some code reuse (e.g. CPU flags, kernel command line).

This does not yet attempt to rework the page tables to handle an arbitrary
physical memory location on x86_64. I would love some suggestions on
how to do this. :)

-Kees

