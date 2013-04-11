Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161617Ab3DKO4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:56:01 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:40773 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161563Ab3DKOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <1365683207-42425-6-git-send-email-trenn@suse.de>
References: <1365683207-42425-1-git-send-email-trenn@suse.de>
	<1365683207-42425-6-git-send-email-trenn@suse.de>
Date: Thu, 11 Apr 2013 07:55:57 -0700
X-Google-Sender-Auth: SK9RAyRyUVJno9ond2FHvGOCEW8
Message-ID: <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead
 of memmap= boot parameter
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Cliff Wickman <cpw@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 5:26 AM, Thomas Renninger <trenn@suse.de> wrote:
> Currently ranges are passed via kernel boot parameters:
> memmap=exactmap memmap=X#Y memmap=
>
> Pass them via e820 table directly instead.

how to address "saved_max_pfn" referring in kernel?

kernel need to use saved_max_pfn from old e820 in
drivers/char/mem.c::read_oldmem()

mips and powerpc they are passing that from command line "savemaxmem="

x86 should use that too?

Thanks

Yinghai
