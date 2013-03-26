Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3CZRq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:46:56 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33691 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab3CZRqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:46:53 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 0/3] mm: avoid duplication of setup_nr_node_ids()
Date: Tue, 26 Mar 2013 10:45:59 -0700
Message-Id: <1364319962-30967-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032617-5806-0000-0000-0000207BF901
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/powerpc, arch/x86, and mm/page_alloc code to setup nr_node_ids based on
node_possible_map is duplicated.

This patchset switches those copies to calling the function provided by page_alloc.

