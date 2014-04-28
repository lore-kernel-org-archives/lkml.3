Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaD1WMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:12:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:38582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaD1WMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="522615330"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Add support for RD/WR FS/GSBASE
Date: Mon, 28 Apr 2014 15:12:34 -0700
Message-Id: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds kernel support for some Intel instructions that
allow fast access to the FS and GS 64bit base. They need
some changes to entry_64.S because they allow user
to fully control the GS base.

Advantages:
- NMIs (and other "paranoid" interrupts) avoid
one RDMSR which makes them faster
- User space can use these instructions, mainly
for efficient context switching with user thread libraries
- Context switches do not need to use MSR writes
anymore to context switch FS/GS base >4GB. This 
will speed up applications that have enough thread
local data that it won't fit below 4GB.
- User space can use GS efficiently as an additional
global pointer register

I also included one minor (unrelated) optimization to 
disable an unneeded old SWAPGS workaround.

-Andi

