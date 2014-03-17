Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaCQR4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:56:10 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40599 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbaCQR4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:56:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,671,1389744000"; 
   d="scan'208";a="112202722"
Message-ID: <53273733.6080506@citrix.com>
Date: Mon, 17 Mar 2014 17:56:03 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>,
        kbuild test robot <fengguang.wu@intel.com>, <kbuild-all@01.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: declare notifier_block on xen-ops.h
References: <5323aab1.r24xwrkmR/N+a3KK%fengguang.wu@intel.com> <20140317074850.GB1767@redhat.com>
In-Reply-To: <20140317074850.GB1767@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/14 07:48, Stanislaw Gruszka wrote:
> Patch fixes below warnings:
> 
>    In file included from arch/x86/xen/xen-ops.h:7:0,
>                     from arch/x86/xen/vga.c:9:
>>> include/xen/xen-ops.h:19:42: warning: 'struct notifier_block' declared inside parameter list [enabled by default]
>     void xen_resume_notifier_register(struct notifier_block *nb);
>                                              ^
>>> include/xen/xen-ops.h:19:42: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>>> include/xen/xen-ops.h:20:44: warning: 'struct notifier_block' declared inside parameter list [enabled by default]
>     void xen_resume_notifier_unregister(struct notifier_block *nb);

Is this a fix up to your previous  "xen/acpi-processor: fix enabling
interrupts on syscore_resume" patch?  If so, do you mind if we squash
the two commits together?  So bisectability is improved.

David
