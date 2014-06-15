Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaFOFyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 01:54:46 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45716 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaFOFyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 01:54:44 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Sun, 15 Jun 2014 01:59:10 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Vineet Gupta <vgupta@synopsys.com>, Steven Miao <realmz6@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-sh@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/6] perf: Use common PMU interrupt disabled code on all
 architectures
Message-ID: <alpine.DEB.2.10.1406150156510.16738@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that "perf/x86: Use common PMU interrupt disabled code"
(c184c980de30dc) was merged, I went and audited all of the
architectures.  The following patchset attempts to move
all of the ones that have code disabling sampled events
due to lack of overflow interrupt to the new common code.

ARM and x86 were already updated with the original changeset.

Note that this is an ABI change in some cases, as many
architectures returned EINVAL previously rather than
EOPNOTSUPP.

Unfortunately these patches are not tested at all, as I don't have
access to the hardware.

