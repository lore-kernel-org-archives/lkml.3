Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab3KFQXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:23:36 -0500
Received: from smtp.citrix.com ([66.165.176.89]:64128 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3KFQXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:23:35 -0500
X-IronPort-AV: E=Sophos;i="4.93,647,1378857600"; 
   d="scan'208";a="71227099"
Date: Wed, 6 Nov 2013 16:22:15 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: swiotlb on arm status
Message-ID: <alpine.DEB.2.02.1311061245580.26077@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,
I thought about giving you a quick summary of the status of the swiotlb
patch series on ARM: it has been in linux-next since last week, a few
issues were found and fixed already.

I went through all the patches and I am still missing few acks on the
arm specific bits:

http://marc.info/?l=linux-kernel&m=138359037113882&w=2
The latest version of the "make SWIOTLB available" patch, on which you
have already commented in the past. This version should address your
previous feedback.

http://marc.info/?l=linux-kernel&m=138269913107769&w=2
This one is about not merging bio_vecs on Xen. The idea and the code is
taken from x86. The arm64 part has been acked by Catalin, but the arm32
part is still missing an ack. It introduces a build issue on
ape6evm_defconfig, fixed separately by the patch below. 

http://marc.info/?l=linux-kernel&m=138374169030300&w=2
A fix for the build issue found by Olof on linux-next on
ape6evm_defconfig.

Cheers,

Stefano
