Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLODca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:32:30 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52207 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaLODc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:32:27 -0500
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Philippe Bergheaud <philippe.bergheaud@fr.ibm.com>
Subject: Re: [PATCH 7/7] CXL: Unmap MMIO regions when detaching a context
In-reply-to: <1418026681-14787-7-git-send-email-imunsie@au.ibm.com>
References: <1418026681-14787-1-git-send-email-imunsie@au.ibm.com> <1418026681-14787-7-git-send-email-imunsie@au.ibm.com>
Date: Mon, 15 Dec 2014 14:32:18 +1100
Message-Id: <1418613792-sup-5165@delenn.ozlabs.ibm.com>
User-Agent: Sup/0.20.0
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121503-0025-0000-0000-000000BC64FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Ian Munsie's message of 2014-12-08 19:18:01 +1100:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> If we need to force detach a context (e.g. due to EEH or simply force
> unbinding the driver) we should prevent the userspace contexts from
> being able to access the Problem State Area MMIO region further, which
> they may have mapped with mmap().
> 
> This patch unmaps any mapped MMIO regions when detaching a userspace
> context.

Might want to drop this one for now - Philippe found that it sometimes
causes an issue when multiple contexts are using the afu. Seems that
unmap_mapping_range() unmapped a bit more than I expected.

Cheers,
-Ian

