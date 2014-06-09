Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaFIB3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 21:29:19 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62931 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaFIB3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 21:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140608181436.17de69ac@redhat.com>
References: <20140608181436.17de69ac@redhat.com>
Date: Sun, 8 Jun 2014 18:29:11 -0700
X-Google-Sender-Auth: DCJuZXrGGDL0m9V-5K8bnBa0hEA
Message-ID: <CAE9FiQXpUbAOinEK-1PSFyGKqpC_FHN0sjP0xvD0ChrXR5GdAw@mail.gmail.com>
Subject: Re: [PATCH] x86: numa: drop ZONE_ALIGN
From: Yinghai Lu <yinghai@kernel.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 8, 2014 at 3:14 PM, Luiz Capitulino <lcapitulino@redhat.com> wrote:
> In short, I believe this is just dead code for the upstream kernel but this
> causes a bug for 2.6.32 based kernels.
>
> The setup_node_data() function is used to initialize NODE_DATA() for a node.
> It gets a node id and a memory range. The start address for the memory range
> is rounded up to ZONE_ALIGN and then it's used to initialize
> NODE_DATA(nid)->node_start_pfn.
> The 2.6.32 kernel did use the rounded up range start to register a node's
> memory range with the bootmem interface by calling init_bootmem_node().
> A few steps later during bootmem initialization, the 2.6.32 kernel calls
> free_bootmem_with_active_regions() to initialize the bootmem bitmap. This
> function goes through all memory ranges read from the SRAT table and try
> to mark them as usable for bootmem usage. However, before marking a range
> as usable, mark_bootmem_node() asserts if the memory range start address
> (as read from the SRAT table) is less than the value registered with
> init_bootmem_node(). The assertion will trigger whenever the memory range
> start address is rounded up, as it will always be greater than what is
> reported in the SRAT table. This is true when the 2.6.32 kernel runs as a
> HyperV guest on Windows Server 2012. Dropping ZONE_ALIGN solves the
> problem there.

What is e820 memmap and srat from HyperV guest?

Can you post bootlog first 200 lines?

Thanks

Yinghai
