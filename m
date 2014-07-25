Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbaGYToQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:44:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48622 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761019AbaGYToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:44:14 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Steven Hill <Steven.Hill@imgtec.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v3 0/2] mm/highmem: make kmap cache coloring aware
Date: Fri, 25 Jul 2014 23:43:45 +0400
Message-Id: <1406317427-10215-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds mapping color control to the generic kmap code, allowing
architectures with aliasing VIPT cache to use high memory. There's also
use example of this new interface by xtensa.

Max Filippov (2):
  mm/highmem: make kmap cache coloring aware
  xtensa: support aliasing cache in kmap

 arch/xtensa/include/asm/highmem.h | 40 +++++++++++++++++-
 arch/xtensa/mm/highmem.c          | 18 ++++++++
 mm/highmem.c                      | 89 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 134 insertions(+), 13 deletions(-)

-- 
1.8.1.4

