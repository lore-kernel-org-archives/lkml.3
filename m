Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbaDBR6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:58:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:52251 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633AbaDBR55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,781,1389772800"; 
   d="scan'208";a="485891657"
From: Andi Kleen <andi@firstfloor.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com
Subject: Re: [PATCH v2 1/5] x86: replace timeouts when booting secondary CPU with infinite wait loop
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
	<1396296565-19709-2-git-send-email-imammedo@redhat.com>
Date: Wed, 02 Apr 2014 10:15:29 -0700
In-Reply-To: <1396296565-19709-2-git-send-email-imammedo@redhat.com> (Igor
	Mammedov's message of "Mon, 31 Mar 2014 22:09:21 +0200")
Message-ID: <87ppkzk5zi.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Mammedov <imammedo@redhat.com> writes:

> Hang is observed on virtual machines during CPU hotplug,
> especially in big guests with many CPUs. (It reproducible
> more often if host is over-committed).
>
> It happens because master CPU gives up waiting on
> secondary CPU and allows it to run wild. As result
> AP causes locking or crashing system. For example
> as described here: https://lkml.org/lkml/2014/3/6/257
>
> If master CPU have sent STARTUP IPI successfully,
> make it wait indefinitely till AP boots.


But what happens on a real machine when the other CPU is dead?

I've seen that. Kernel still boots. With your patch it would
hang.

I don't think you can do that. It needs to have some timeout.
Maybe a longer or configurable one?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
