Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3A2Cbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:31:31 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55205 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3A2Cb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:31:29 -0500
MIME-Version: 1.0
In-Reply-To: <4302d59f-5c87-4b82-af16-9f54625fc9ce@email.android.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
	<CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com>
	<CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com>
	<6950516.1uefDuthAH@hammer82.arch.suse.de>
	<510721C6.6080705@zytor.com>
	<CAE9FiQWDcFR+6L-GiR6rk60TC0zH=xewyH_h1Rx_QB+8PTiU3Q@mail.gmail.com>
	<51072FEF.50000@zytor.com>
	<CAE9FiQVG4ShGKSdjzYhQaXNNhS=MVNJg=QqG1yW-mAUscErXMA@mail.gmail.com>
	<4302d59f-5c87-4b82-af16-9f54625fc9ce@email.android.com>
Date: Mon, 28 Jan 2013 18:31:28 -0800
X-Google-Sender-Auth: 5kgQpbhlDB2MZLozwM94dFYuK2E
Message-ID: <CAE9FiQUDP9x+6CZKyW8CVq7YWy+zQwSTqm67G-AuX0=LYgqf6A@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 6:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> To be more clear: the max_pfn stuff seems like a relic of the past, and I am wondering what it would take to get rid of it.
>
> It clearly has the wrong semantics, except perhaps in the most trivial allocator models.
>
one thing i think could be : use that decide if we need iommu/swiotlb.
like in
arch/x86/kernel/amd_gart_64.c
arch/x86/kernel/pci-swiotlb.c
drivers/iommu/amd_iommu.c
...

Yinghai
