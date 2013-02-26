Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3BZGaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:30:25 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62289 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3BZGaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:30:24 -0500
Message-ID: <512C567D.6010602@paintedocean.com>
Date: Mon, 25 Feb 2013 22:30:21 -0800
From: Neil Salstrom <salstrom@paintedocean.com>
Reply-To: salstrom@paintedocean.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:21.0) Gecko/20100101 Thunderbird/21.0a2
MIME-Version: 1.0
To: edumazet@google.com, davem@davemloft.net
CC: linux-kernel@vger.kernel.org
Subject: Regression found in loopback.c patch (0cf833a)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I believe I have found a regression in drivers/net/loopback.c which was
introduced starting with the v3.7 kernel series (and also affects
v3.8).  Oddly enough, it affects DVD playback (both physical disk and
.iso files) in MythTV (I'm using v0.26 and compile from source).  I
don't know if MythTV mounts a .iso or DVD over a loopback device but for
whatever reason there is a problem.

When playing a DVD there is a constant stuttering of the video and
corresponding audio dropouts.  This is continual with mythfrontend logs
showing "Waiting for video buffers."

I found that any kernel before v3.7 did not cause this issue so I did a
git bisect between v3.6 and v3.7.  The resulting bisection was to commit
0cf833a (net: loopback: set default mtu to 64K).

I downloaded the source to v3.7.9 and reverted the line:

dev->mtu = 64 * 1024;

back to:

dev->mtu = (16 * 1024) + 20 + 20 + 12;


The resulting kernel did not cause the playback stuttering.  I have also
compiled v3.8.0 using (16 * 1024) + 20 + 20 + 12; and again had no problems.

Please let me know if you have any questions.

Thank you,

Neil Salstrom


