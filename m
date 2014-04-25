Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaDYOWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:22:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:53538 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbaDYOWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="499742605"
Date: Fri, 25 Apr 2014 07:22:48 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Oren Twaig <oren@scalemp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2] X86: Hook apic vector allocation domain only when
 interrupt routing are set to ignore
Message-ID: <20140425142248.GL8874@tassilo.jf.intel.com>
References: <1398376326-3055-1-git-send-email-oren@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398376326-3055-1-git-send-email-oren@scalemp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
> index f6584a9..b7f8e5b 100644
> --- a/arch/x86/kernel/vsmp_64.c
> +++ b/arch/x86/kernel/vsmp_64.c
> @@ -26,6 +26,8 @@
>  
>  #define TOPOLOGY_REGISTER_OFFSET 0x10
>  
> +static int irc = 1;

Using a static for such state is very unusual. You need to describe what
protects it against races and why that is needed over a cleaner solution.

-Andi
