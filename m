Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3HPRj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:39:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38183 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3HPRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:39:50 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [RFC PATCH v2 0/4] DT: move of_get_cpu_node from PPC to DT core
Date: Fri, 16 Aug 2013 18:39:49 +0100
Message-Id: <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 16 Aug 2013 17:39:45.0438 (UTC) FILETIME=[98D11BE0:01CE9AA7]
X-MC-Unique: 113081618394800201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7GHe0Ll024387

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Hi,

This series needs to be prepended with the original series[1][2][3]
Except the first patch in the original series(which is merged into this
as last patch), there is no other change(apart from function signature)
I am posting only this part for feedback separately for review as the
original series is already reviewed and acked.

v1->v2:
- Fixed an issue - updating cell pointer
- Documentated in arch_match_cpu_phys_id that phys_id are values read
  from the device tree only in the weak definition

[Since first 2 patches have not changed, microblaze and openrisc lists are
bouncing for non-members, I am not resending them again. Michal(for
microblaze) has acked when it was first pointed. I am waiting for response
from Jonas(for openrisc)]

Rob, Ben,

If you are OK with these patches and ACK, I can combine and post the complete
series.

Regards,
Sudeep

Sudeep KarkadaNagesha (4):
  microblaze: remove undefined of_get_cpu_node declaration
  openrisc: remove undefined of_get_cpu_node declaration
  powerpc: refactor of_get_cpu_node to support other architectures
  of: move of_get_cpu_node implementation to DT core library

 arch/microblaze/include/asm/prom.h |  3 --
 arch/openrisc/include/asm/prom.h   |  3 --
 arch/powerpc/include/asm/prom.h    |  3 --
 arch/powerpc/kernel/prom.c         | 43 +----------------
 drivers/of/base.c                  | 96 ++++++++++++++++++++++++++++++++++++++
 include/linux/cpu.h                |  1 +
 include/linux/of.h                 |  7 +++
 7 files changed, 106 insertions(+), 50 deletions(-)

-- 
1.8.1.2


