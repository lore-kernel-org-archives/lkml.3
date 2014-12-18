Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaLRAkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:40:04 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36081 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaLRAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:40:01 -0500
Date: Wed, 17 Dec 2014 16:39:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: akpm@linux-foundation.org, Dmitry Vyukov <dvyukov@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "nadia.derbey@bull.net" <Nadia.Derbey@bull.net>, aquini@redhat.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm: hugetlb: fix type of hugetlb_treat_as_movable
 variable
In-Reply-To: <1418826650-10145-2-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.10.1412171639430.23841@chino.kir.corp.google.com>
References: <548CA6B6.3060901@colorfullife.com> <1418826650-10145-1-git-send-email-a.ryabinin@samsung.com> <1418826650-10145-2-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Andrey Ryabinin wrote:

> hugetlb_treat_as_movable declared as unsigned long, but
> proc_dointvec() used for parsing it:
> 
> static struct ctl_table vm_table[] = {
> ...
> 	{
> 		.procname	= "hugepages_treat_as_movable",
> 		.data		= &hugepages_treat_as_movable,
> 		.maxlen		= sizeof(int),
> 		.mode		= 0644,
> 		.proc_handler	= proc_dointvec,
> 	},
> 
> This seems harmless, but it's better to use int type here.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

Acked-by: David Rientjes <rientjes@google.com>
