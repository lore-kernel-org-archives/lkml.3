Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3DKLuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:50:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:60390 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab3DKLuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:50:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,454,1363158000"; 
   d="scan'208";a="316553201"
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Alex Shi <alex.shi@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH v3] x86: use a read-only IDT alias on all CPUs
References: <20130410192422.GA17344@www.outflux.net>
	<20130411083634.GA11824@gmail.com>
Date: Thu, 11 Apr 2013 04:50:14 -0700
In-Reply-To: <20130411083634.GA11824@gmail.com> (Ingo Molnar's message of
	"Thu, 11 Apr 2013 10:36:34 +0200")
Message-ID: <m261ztxp55.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:
>
> This looks very nice to me now. Peter, any objections?

it seems pointless without randomized main kernel text location, because
the IDT will be still at a known per kernel fixed writable location in
the direct mapping.

As long as such randomization is not there it just wastes a TLB entry.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
