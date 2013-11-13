Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403Ab3KMIRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:17:00 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:35238 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759289Ab3KMIQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:16:31 -0500
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 0/2] sched: finish_switch_mm hook
Date: Wed, 13 Nov 2013 09:16:12 +0100
Message-Id: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111308-0542-0000-0000-0000070BD6B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in order to implement TLB flushing on s390 in a way that is 100%
compliant with the architecture I would like to introcude a new
hook to the scheduler. In concept it pairs with the switch_mm
function and is called after all locks have been released to
complete the switch_mm operation. The use case for s390 boils
down to the ability to wait for another CPU in switch_mm/
finish_switch_mm.

Right now the issue is theoretical and can only show up under
a extreme race condition in combination with a buggy user space
program. But to implement local TLB flushing which has been
added to the latest machine (zEC12) the finish_switch_mm hook
will be needed.

Patch #2 of the series is included as reference and shows how the
finish_switch_mm hook would be used in s390 code. The description
of the patch has more details why the hook is needed.

-- 
1.7.9.5

