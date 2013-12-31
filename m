Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3LaPP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 10:15:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44214 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3LaPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:15:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: 
Date: Tue, 31 Dec 2013 10:15:18 -0500
Message-Id: <1388502919-8601-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This had been posted way way back:  https://lkml.org/lkml/2013/1/16/696

and the discussion about it was:
 - If there are no uses of v2, then why not rip out the support for it.
   [b/c the work for it would be in the networking code and I am still
    hoping that will be done?]
 - Why not do all of this in the toolstack. Enforce that the guest
   can only use v1 ".. if the backend isn't going to make use of them."
   (Matt).
   I am not sure how one would set up the plumbing to properly figure out
   whether the backend (say a driver domain) would communicate to hypervisor
   or XenBus that it is going to use v1 only if it has not yet started.
   (It would not have started b/c the guest hasn't started yet).

   My thinking is that once the frontend and backend start using the
   esoteric features of v2 we can rip this patch out. And also implement
   the proper code for PVHVM/PVH to actually use v2 grants.


