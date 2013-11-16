Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab3KPO4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:56:33 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:37627 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3KPO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:56:25 -0500
MIME-Version: 1.0
Date: Sat, 16 Nov 2013 09:56:24 -0500
X-Google-Sender-Auth: SnHS1CZBhDn2yWcS1mlLSc-9H70
Message-ID: <CA+5PVA7YMMRmFE=T7MOdGNeUiv_4Eu_u2-SrDfSTE052MpAnag@mail.gmail.com>
Subject: xen drivers fail to link on ARM with v3.12-9888-gf63c482
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>, xen-devel@lists.xenproject.org,
        linux-arm-kernel@lists.infradead.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The xen-gntalloc, xen-netfront, xen-blkfront, and xen-netback drivers
fail to link on ARM today with the following error:

ERROR: "phys_to_mach" [drivers/xen/xen-gntalloc.ko] undefined!
ERROR: "phys_to_mach" [drivers/net/xen-netfront.ko] undefined!
ERROR: "phys_to_mach" [drivers/net/xen-netback/xen-netback.ko] undefined!
ERROR: "phys_to_mach" [drivers/block/xen-blkfront.ko] undefined!

This is with Linus' tree as of this morning.

I'm guessing this is because the mfn_to_pfn and pfn_to_mfn functions
are inlined and reference phys_to_mach directly, and that isn't
exported to modules.  Thoughts?

josh
