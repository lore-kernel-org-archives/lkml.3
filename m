Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab3AOQht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:37:49 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:65382 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3AOQhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1301151242000.4978@kaball.uk.xensource.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-11-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1301151242000.4978@kaball.uk.xensource.com>
Date: Tue, 15 Jan 2013 08:37:46 -0800
X-Google-Sender-Auth: o_B-sn9HRVrB_tJmzmIe2JLsgKw
Message-ID: <CAE9FiQUDYbkP7n_nYL-OPNrC__Z7kWzTGjm0dKmHzYY=JrincQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 10/31] x86, 64bit: Don't set max_pfn_mapped wrong
 value early on native path
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 5:48 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:

>
> If you are going to put a comment like that in the code, could you
> please at least add some useful details, rather than a generic
> "somehow"? It doesn't seem very helpful to me or to any other hackers
> looking at the code.
>
> The issue is even described as a comment in the code at the beginning of
> arch/x86/xen/mmu.c:xen_setup_kernel_pagetable:
>
> /* max_pfn_mapped is the last pfn mapped in the initial memory
>  * mappings. Considering that on Xen after the kernel mappings we
>  * have the mappings of some pages that don't exist in pfn space, we
>  * set max_pfn_mapped to the last real pfn mapped. */
>
> Now if max_pfn_mapped is supposed to represent the last pfn mapped in
> the initial memory mapping, then I think that the way Xen uses
> max_pfn_mapped is actually correct.

change the comments to:

+       /*
+        * Native path, max_pfn_mapped is not set yet.
+        * Xen has valid max_pfn_mapped set in
+        *      arch/x86/xen/mmu.c:xen_setup_kernel_pagetable().
+        */


Thanks

Yinghai
