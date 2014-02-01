Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaBAXqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 18:46:22 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43713 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaBAXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 18:46:21 -0500
Date: Sat, 1 Feb 2014 15:46:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Tesarik <ptesarik@suse.cz>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] x86: fix the initialization of physnode_map
In-Reply-To: <20140201133019.32e56f86@hananiah.suse.cz>
Message-ID: <alpine.DEB.2.02.1402011546040.4865@chino.kir.corp.google.com>
References: <20140201133019.32e56f86@hananiah.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Feb 2014, Petr Tesarik wrote:

> With DISCONTIGMEM, the mapping between a pfn and its owning node is
> initialized using data provided by the BIOS. However, the initialization
> may fail if the extents are not aligned to section boundary (64M).
> 
> The symptom of this bug is an early boot failure in pfn_to_page(),
> as it tries to access NODE_DATA(__nid) using index from an unitialized
> element of the physnode_map[] array.
> 
> While the bug is always present, it is more likely to be hit in kdump
> kernels on large machines, because:
> 
> 1. The memory map for a kdump kernel is specified as exactmap, and
>    exactmap is more likely to be unaligned.
> 
> 2. Large reservations are more likely to span across a 64M boundary.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>
