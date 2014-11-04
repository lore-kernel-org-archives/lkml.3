Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaKDBAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:00:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:36876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbaKDBAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:00:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="410858178"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Fixes for the Haswell EP uncore driver
Date: Mon,  3 Nov 2014 17:00:25 -0800
Message-Id: <1415062828-19759-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch is the "proper" fix for the SBOX boot crash on some
system. It replaces the disabling patch I submitted earlier.
If we write the initialization bits in different WRMSRs the
problem goes away.

Also fix another problem with wrong register offsets in the IRP
unit driver, thanks to Patrick Lu.

Finally fix the units for the memory controller (third
patch is optional, but harmless)

-Andi

