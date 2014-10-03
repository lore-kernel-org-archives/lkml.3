Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaJCW36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:29:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbaJCW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:26:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 103/143] percpu: free percpu allocation info for uniprocessor system
Date: Fri,  3 Oct 2014 14:34:58 -0700
Message-Id: <20141003213317.581954072@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honggang Li <enjoymindful@gmail.com>

commit 3189eddbcafcc4d827f7f19facbeddec4424eba8 upstream.

Currently, only SMP system free the percpu allocation info.
Uniprocessor system should free it too. For example, one x86 UML
virtual machine with 256MB memory, UML kernel wastes one page memory.

Signed-off-by: Honggang Li <enjoymindful@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1910,6 +1910,8 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
+
+	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */


