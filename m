Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaEPVEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:04:04 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:54713 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaEPVEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:04:01 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 16 May 2014 17:07:54 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        vincent.weaver@maine.edu
Subject: [PATCH 0/3] perf: disable sampled events if no PMU interrupt
Message-ID: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This patch series adds a common shared interface for returning ENOTSUPP
if a user tries to create a sampled event (one with sample_period set)
on a machine that has no usable PMU interrupt.

Currently only x86 and ARM are implemented but if the patch is accepted
then we can move other architectures over to use the interface.

This patch also has the side effect of enabling perf to work on 
raspberry-pi machines.

Consideration should also be given to disabling sampling support on 
machines with buggy PMU interrupts (such as Cortex-A8 and Cortex-A9
ARM platforms).

Vince
