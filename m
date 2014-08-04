Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaHDRXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:23:45 -0400
Received: from shelob.surriel.com ([74.92.59.67]:57979 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaHDRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:23:43 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, mingo@kernel.org,
        vincent.guittot@linaro.org, Morten.Rasmussen@arm.com,
        nicolas.pitre@linaro.org, efault@gmx.de
Subject: [PATCH 0/2] node capacity fixes for NUMA balancing
Date: Mon,  4 Aug 2014 13:23:26 -0400
Message-Id: <1407173008-9334-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NUMA balancing code has a few issues with determining the
capacity of nodes, and using it when doing a task move.

First the NUMA balancing code does not have the equivalent of
c61037e9 to fix the "phantom cores" phenomenon in the presence
of SMT.

Secondly, the NUMA balancing code will happily move a task from
a node that is loaded to capacity, to another node that is
loaded to capacity. This can leave the second node overloaded.

