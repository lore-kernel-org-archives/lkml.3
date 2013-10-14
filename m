Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785Ab3JNEif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 00:38:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:36004 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab3JNEie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 00:38:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,489,1378882800"; 
   d="scan'208";a="418679772"
From: Andi Kleen <andi@firstfloor.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
Date: Sun, 13 Oct 2013 21:38:33 -0700
In-Reply-To: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com> (Neil
	Horman's message of "Fri, 11 Oct 2013 12:51:38 -0400")
Message-ID: <87siw4xy9i.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> writes:

> Sébastien Dugué reported to me that devices implementing ipoib (which don't have
> checksum offload hardware were spending a significant amount of time computing

Must be an odd workload, most TCP/UDP workloads do copy-checksum
anyways. I would rather investigate why that doesn't work.

That said the change looks reasonable, but may not fix the root cause.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
