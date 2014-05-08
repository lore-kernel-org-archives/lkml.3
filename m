Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaEHWW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:22:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:37627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaEHWW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:22:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1014,1389772800"; 
   d="scan'208";a="508666476"
Message-ID: <536C039A.5000204@intel.com>
Date: Thu, 08 May 2014 15:22:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: KVM_GUEST support breaks page fault tracing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed on some of my systems that page fault tracing doesn't work:

	cd /sys/kernel/debug/tracing
	echo 1 > events/exceptions/enable
	cat trace;
	# nothing shows up

I eventually traced it down to CONFIG_KVM_GUEST.  At least in a KVM VM,
enabling that option breaks page fault tracing, and disabling fixes it.
 I tried on some old kernels and this does not appear to be a
regression: it never worked.

Anybody have any theories about what is going on?

I'm also having problems with the page fault tracing on bare metal (same
symptom of no trace output).  I'm unsure if it's related.
