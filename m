Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaI0REd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 13:04:33 -0400
Received: from imap.imec.msu.ru ([93.180.3.203]:55089 "EHLO imap.imec.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbaI0REc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 13:04:32 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2014 13:04:32 EDT
Date: Sat, 27 Sep 2014 20:56:52 +0400
From: Alexander Inyukhin <shurick@sectorb.msk.ru>
To: linux-kernel@vger.kernel.org
Subject: x86: irq: Duplicate interrupt name THR
Message-ID: <20140927165652.GA18719@shurick.grid.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The interrupt name "THR" used twice for x86 architecture.
It is used for "Threshold APIC interrupts" and
"Hypervisor callback interrupts".

I don't know if duplicates are a valid for /proc/interrupt table,
but this could lead to problems with user space applications,
as they have to parse not only interrupt name, but a description too.

The duplicate was introduced by commit 929320e4b4c10708d3477d7e395f0ce7b0cc8744
