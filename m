Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaLNL6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 06:58:42 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:61128 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaLNL6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 06:58:41 -0500
Date: Sun, 14 Dec 2014 12:58:31 +0100
From: Heinz Diehl <htd+ml@fritha.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [Regression] 3.18 black screen after boot (bisected)
Message-ID: <20141214115831.GA1634@fritha.org>
Reply-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
User-Agent: Mutt/1.5.23+16 (39d3ddb56d34) (2014-03-12)
X-Provags-ID: V03:K0:FT9oA5wjY09D8v41tz9kHZ05fNYK1gSS5+4h861QinX2R6aj5hB
 mTEla70ZmykkgZ6e0jxXOEsHJQp56OuzYQHZm+9DuTGtvBJHIU/0/aJtdr0YArcdk87MCWI
 X1ti43IhWRItXRjrUOUaiIn8gRMcaAxpCkt3Nwe14k2DtP97zmkuIvp3cJ1wdiigMY1qWnN
 rZkKbUQUATvi89Ds6LCCw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since kernel 3.18 I'm no longer able to run X on my machine. While
3.17.6 is fine, 3.18 leaves me with a black screen when starting
X. Booting into runlevel 1/3 is fine.

I did a "git bisect", and the offending commit is this one:

[root@kiera linux-git]# git bisect bad
83f45fc360c8e16a330474860ebda872d1384c8c is the first bad commit
commit 83f45fc360c8e16a330474860ebda872d1384c8c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed Aug 6 09:10:18 2014 +0200

    drm: Don't grab an fb reference for the idr

[....]

I double-checked, and 3.18 is fine with this commit reverted.

My machine is an Asus U45JC laptop, and the CPU is an Intel i450M
(Ironlake). Please contact me if I can help in any way (I'm subscribed
to lkml, but not to other X or kernel related lists).

Thanks,
 Heinz.


