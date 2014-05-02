Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaEBVsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:48:41 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62763 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaEBVsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:48:40 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 2 May 2014 22:48:20 +0100
X-Google-Sender-Auth: W-eTt6IUorH5SOULhgtVYiC8K80
Message-ID: <CACxGe6u8gTypr7zBYzir=4EpnQmZB7-Am7JsRrEqsohb4zZHmw@mail.gmail.com>
Subject: [git pull] drivercore deferred probe bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This was the pending bug fix I mentioned in my previous pull request.
Normally this would go through Greg's tree seeing that it is a
drivercore change, but devicetree exposes the problem. I've discussed
with Greg and he okayed me asking you to pull directly.

Cheers,
g.

The following changes since commit 9ec36cafe43bf835f8f29273597a5b0cbc8267ef:

  of/irq: do irq resolution in platform_get_irq (2014-04-24 21:40:22 +0100)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/dt-for-linus

for you to fetch changes up to 58b116bce13612e5aa6fcd49ecbd4cf8bb59e835:

  drivercore: deferral race condition fix (2014-04-29 15:44:05 +0100)

----------------------------------------------------------------
Drivercore race condition fix (exposed by devicetree)

This branch fixes a bug where a device can get stuck in the deferred
list even though all its dependencies are met. The bug has existed for a
long time, but new platform conversions to device tree have exposed it.
This patch is needed to get those platforms working.

----------------------------------------------------------------
Grant Likely (1):
      drivercore: deferral race condition fix

 drivers/base/dd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
