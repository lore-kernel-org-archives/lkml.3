Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaDWWB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:01:28 -0400
Received: from mout.gmx.net ([212.227.15.18]:53174 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbaDWWB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:01:26 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: f2fs causes system stall
Date: Thu, 24 Apr 2014 00:00:59 +0200
Message-ID: <2601952.jk1l5iHOJT@ax5200p>
User-Agent: KMail/4.13 (Linux/3.13.0-24-generic; KDE/4.13.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:arSfVl/+6XxJPRe5/6yZMSJUyRH6OIrqCQQriiRpkS/lC0Vxp/Z
 FXXmvYw1iCFSVsbyLTSHkcOuMX5bxauLt1ggwunaxsGGrdmHNJrxnddeY2m2OMsMz0PxUHf
 Km8GAkv1PWKDx/VeeqPK8p4qXyGwUOBE1eemSVNgJUCuKbmh4Vxrc/YUcSHQCPCT4k/pO9f
 1kMcANfTbJ/HmLwYBtasg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it took me a while to bisect a problem which causes my ARM (tegra2) netbook to 
frequently stall for 5-10 seconds when I enable EXA acceleration (opentegra 
experimental ddx). I can only guess that the offending commit 8618b88 "f2fs: 
fix not to write data pages on the page reclaiming path" somehow causes high 
kernel latencies which may interrupt/disturb the command stream to the gpu in 
this particular case. Reverting this commit fixes the problem. Any hints?

Regards,

Marc

