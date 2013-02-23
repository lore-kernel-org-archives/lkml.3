Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab3BWGbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 01:31:00 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:43116 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3BWGa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 01:30:58 -0500
MIME-Version: 1.0
X-Originating-IP: [76.122.121.143]
Date: Sat, 23 Feb 2013 01:30:57 -0500
Message-ID: <CAKb8eTkimk2jXAqPVUWcoQKFBba+=kpH96gRqx9pGGFFXGf15g@mail.gmail.com>
Subject: ARM: ixp4xx regression (bisected) since v3.5-rc1
From: Brad Parker <bparker@reach3d.net>
To: linux-kernel@vger.kernel.org
Cc: rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using an ADI Pronghorn Metro board and noticed an issue with any
kernel >= 3.5-rc1 where the board would not boot (or at least no
console messages appear over the serial port), just giving
"Uncompressing Linux... done, booting the kernel." and stopping there.

I ran a git bisect between v3.4 and v3.5 and narrowed the problem down
to this commit:

---
c23bfc3835173f5229b2503e3b616001a28affad is the first bad commit
commit c23bfc3835173f5229b2503e3b616001a28affad
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Sat Mar 10 12:49:16 2012 +0000

    ARM: PCI: provide a default bus scan implementation
---

I then reversed this commit on 3.7.9 and the board booted
successfully. I'm not sure if this affects other boards of the same
arch or not, I only have access to a Pronghorn which also requires a
patch for the board files as they are not part of mainline.
