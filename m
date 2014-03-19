Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbaCSHHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:07:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52924 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbaCSG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:27 -0400
Message-Id: <20140319064729.660482086@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/31] Clean up smp_mb__ barriers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a respin (and per arch breakout) of the first 3 patches that spawned
this large C11 atomics thread.

These patches deprecate smp_mb__{before,after}_{atomic_{inc,dec},clear_bit}()
and replace it by just the two smp_mb__{before,after}_atomic().

Assuming people like this; how would we go about merging it? Can we stuff it
into tip/locking/core or something?

Its been compile tested for everything I have a working compiler for.

