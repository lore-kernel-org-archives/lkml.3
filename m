Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaFWOSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:18:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:34147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaFWOSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:18:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="559658149"
Date: Mon, 23 Jun 2014 07:18:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Oren Twaig <oren@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86, vsmp: Remove is_vsmp_box() from
 apic_is_clustered_box()
Message-ID: <20140623141803.GC8178@tassilo.jf.intel.com>
References: <53A7BC92.3080307@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A7BC92.3080307@scalemp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:35:14AM +0300, Oren Twaig wrote:
> Remove invalid code which caused TSC to be declared as "unstable" on vSMP
> Foundation box even if it was stable and let the kernel decide for itself.
> 
> When a vSMP Foundation box is detected, the function apic_cluster_num() counts
> the number of APIC clusters found. If more than one found, a multi board
> configuration is assumed, and TSC marked as unstable. This behavior is
> incorrect as vSMP Foundation may use processors from single node only, attached
> to memory of other nodes - and such node may have more than one APIC cluster
> (typically any recent intel box has more than single APIC_CLUSTERID(x)).
> 
> To fix this, we simply remove the code which detects a vSMP Foundation box and
> affects apic_is_clusted_box() return value. This can be done because later the
> kernel checks by itself if the TSC is stable using the
> check_tsc_sync_[source|target]() functions and marks TSC as unstable if needed.

Looks good to me. Yes the APIC cluster check is obsolete.

-andi
