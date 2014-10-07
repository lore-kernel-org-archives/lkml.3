Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaJGT1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:27:25 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:42295 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaJGT1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:27:24 -0400
From: minyard@acm.org
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 
Date: Tue,  7 Oct 2014 14:27:11 -0500
Message-Id: <1412710034-16908-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm dealing with issues with bad backtraces in MIPS kdumps.  This
patch series fixes the issues with these backtraces.

Note that this does not currently enable DWARF unwinding on the
restore side.  It's less useful (unless you have a backtrace that
runs through the restore code).  It could be done, I think,
without major hassle, but I'll save that for future assuming
these sorts of changes are ok.

Those moves a lot of generic stuff from the x86 dwarf2.h to a new
asm-generic version, but does not make any functional changes to
that code.

