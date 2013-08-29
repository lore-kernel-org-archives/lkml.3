Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3H2TPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:15:06 -0400
Received: from mout.gmx.net ([212.227.17.21]:62718 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab3H2TPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:15:04 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: pageexec@freemail.hu, llvmlinux@lists.linuxfoundation.org,
        behanw@converseincode.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH] [RFC] [X86] Fix a compilation issue with clang.
Date: Thu, 29 Aug 2013 21:13:03 +0200
Message-Id: <1377803585-5913-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1563930.LeGpPqNO9R@aragorn.auenland.lan>
References: <1563930.LeGpPqNO9R@aragorn.auenland.lan>
X-Provags-ID: V03:K0:ds8EBCSssf3Mk2bvvnZPfjDsjpxHJOBgeYT5EER/fQX+7alvtxH
 ySCHA6oie/FaKsd8Yq8zi7nCSx7/6jo7H7b2hUhGYmws2DRWa9yni+hlRp86fX5IGijuGuL
 ccysthHzrNPQpd/OytZKMfYzXBj17a0dSJHo3kLtICO8ilVQqbId041db8+Pt+rfAw+zBe+
 C3IjwzVbBYSroEDto5Vag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These to patches fix a compilation issues with clang.

[PATCH 1/2] Extend definitions of __ASM_* with a raw format.

Extends the helper macros __ASM_*  (e.g. __ASM_DX) with a format that 
does not add whitespace. Both gcc and clang choke in that case.

[PATCH 2/2] [X86] Fix a compilation issue with clang.

This is the actual issue here. In the 64bit case, clang just sees
edx (a 32bit register name) and does not use more than 32bit.
As pointed out in the comment in uaccess.h, gcc is happy with edx as the
starting point (and does not care about the size).
This fix pleases both worlds as we just use edx on 32 and rdx on 64.

Please apply.

CC: pageexec@freemail.hu
CC: llvmlinux@lists.linuxfoundation.org
CC: behanw@converseincode.com
CC: hpa@zytor.com
CC: linux-kernel@vger.kernel.org
