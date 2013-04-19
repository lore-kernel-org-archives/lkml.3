Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726Ab3DSXNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 19:13:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab3DSXNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 19:13:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
Date: Sat, 20 Apr 2013 01:13:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: "Lars-Peter Clausen" <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <1366364534-3298-2-git-send-email-lars@metafoo.de> <5171C8F6.6010702@ti.com>
In-Reply-To: <5171C8F6.6010702@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304200113.02908.arnd@arndb.de>
X-Provags-ID: V02:K0:z7lEudkUPiBLUg32IwYhKTU9O42PVZySJJwjbVaY9OG
 F2WfwE402xuUOteheohChbOEtvtWKAzbKcfJ9uCs63qKShomY+
 g6ISsVZ9SNdcakpU2YvPEb2kJ4l9JTZ4NrOdwG+k1sYlmILTLA
 /liEB4doM6WKH0kGeJfnuvZ4TRyZWtRTGPcBWg43dZexIeEcsr
 9ErgCd/Dd4pRp3dEK1tbNafotC+cMwQcr+wQN8MH/yTRwanBFZ
 RV521nUpP+prAnO4CakatgWJucoas83/C4B1nluswBQKqQRQ22
 3aircRONJQ8H05ZooNjGo4pQ/SAZwyEzRA0jZIIrqCYoTR6bh2
 VZUpwL1AfqeQz/Nf9UYc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 April 2013, Jon Hunter wrote:
> Change also means that of_dma_request_slave_channel() cannot be called
> from a context where it is not possible to sleep too, right? May be
> worth mentioning this in the changelog as well.

You already cannot do that, because it requires dma_list_mutex.

	Arnd
