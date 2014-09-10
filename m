Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaIJXgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:36:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25597 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaIJXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:36:22 -0400
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [V5 PATCH 0/1] x86/xen: Set EFER.NX and EFER.SCE in PVH guests
Date: Wed, 10 Sep 2014 16:36:05 -0700
Message-Id: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Attached V5 patch for fixing the EFER bugs on PVH.

Changes in v5 (Mukesh):
  - Jan reminded us that vcpu 0 could go offline/online. So, add flag back 
    instead of using cpuid to return from xen_pvh_early_cpu_init.
  - Boris comments: 
       o Rename to xen_pvh_early_cpu_init
       o Add ifdef around pvh functions in enlighten.c too.
  - Tab before closing brace to pacify checkpatch.pl

Changes in v4 (David):
  - cpu == 0 => boot CPU
  - Reduce #ifdefs.
  - Add patch for XEN_PVH docs.

Changes in v3 (David):
  - Use common xen_pvh_cpu_early_init() function for boot and secondary
    VCPUs.

Changes in v2: (Mukesh):
  - Use assembly macro to unify code for boot and secondary VCPUs.

