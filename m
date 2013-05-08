Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3EHMKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:10:54 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60620 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3EHMKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:10:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,634,1363132800"; 
   d="scan'208";a="22855988"
Date: Wed, 8 May 2013 13:10:30 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Julien Grall <julien.grall@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [PATCH 0/3] Xen ARM fixes for 3.10-RC1
Message-ID: <alpine.DEB.2.02.1305081303310.18865@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this small patch series fixes few Xen on ARM problems I found with more
testing:

- in order to work in dom0, we need to delay the initilization of the pm
  functions after arch_init;

- VCPUOP_register_vcpu_info needs to be executed by each online cpu
  separately;

- VCPUOP_register_vcpu_info is not actually supposed to fail.



Stefano Stabellini (3):
      xen/arm: initialize pm functions later
      xen/arm: do not handle VCPUOP_register_vcpu_info failures
      xen: rename xen_secondary_init and run it on every online cpu

 arch/arm/xen/enlighten.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)
