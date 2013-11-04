Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3KDQuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:50:54 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:37660 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3KDQuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:50:52 -0500
Date: Mon, 4 Nov 2013 16:50:43 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, Liu Yu <yu.liu@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Shan Hai <shan.hai@windriver.com>
Subject: [PATCH 0/6] powerpc/math-emu: e500 SPE float emulation fixes
Message-ID: <Pine.LNX.4.64.1311041649250.4290@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 04 Nov 2013 16:50:46.0828 (UTC) FILETIME=[0250CEC0:01CED97E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes various problems with the floating-point
emulation code for powerpc e500 SPE (some being issues with the
e500-specific emulation code, some with the generic math-emu headers).
All six patches were sent individually last month as the issues were
identified and fixed in the course of preparing the e500 glibc port,
and received no comments.  There are no substantive changes to the
patches in this version, but I've retested the glibc port (which is
now upstream, along with all the generic math-emu changes relevant to
the glibc soft-fp code, and various fixes to soft-fp corresponding to
fixes in the kernel code in the hope that at some point we can get the
kernel using the current soft-fp code again) with current kernel
sources with this patch series applied.

The only dependencies between patches in this series should be that
patch 5 (fix e500 SPE float to integer and fixed-point conversions)
depends on patch 2 (fix e500 SPE float rounding inexactness
detection).  Other than that, I think any subset of the patches can be
applied in any order, if some subset seems OK but there are concerns
about other patches in the series.

-- 
Joseph S. Myers
joseph@codesourcery.com
