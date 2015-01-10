Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbbAJDG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 22:06:59 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:43103 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbbAJDG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 22:06:58 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1501091849250.3078@nftneq.ynat.uz>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
	<54AE7D53.2020305@redhat.com>
	<20150108134520.GC14200@e104818-lin.cambridge.arm.com>
	<54AEBE84.6090307@redhat.com>
	<20150108173408.GF17290@e104818-lin.cambridge.arm.com>
	<54AED10C.7090305@redhat.com>
	<CA+55aFwpwkjRnTzBe2K0y+2DOH1F=5SpJkYe=P5z8ps5_1PQHQ@mail.gmail.com>
	<20150109232707.GA6325@e104818-lin.cambridge.arm.com>
	<20150110003540.GA32037@node.dhcp.inet.fi>
	<CA+55aFz74hjhCcdz5J4r-xK4KW7oqNDA3i=jXHW0prGMMwgMvw@mail.gmail.com>
	<alpine.DEB.2.02.1501091849250.3078@nftneq.ynat.uz>
Date: Fri, 9 Jan 2015 19:06:57 -0800
X-Google-Sender-Auth: bDpRVtDLw-NO3iyzHnnEWWjCfko
Message-ID: <CA+55aFy+7+-8CHpmOjRXh1txpABRK3PC+7yZ+fESVAmveOWDyw@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Lang <david@lang.hm>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 6:51 PM, David Lang <david@lang.hm> wrote:
>
> what about a dedicated virtualization host (where your workload is a handful
> of virtual machines), would the file cache issue still be overwelming, even
> though it's the virtual machines accessing things?

How much filesystem caches does the host need or use? It can range
from basically zero ("pure" hypervisor host with no filesystem at all)
to 100% (virtual filesystem in all the clients with the host doing all
the real work).

I dunno. I do know that you definitely don't want to haev a
desktop/workstation with 64kB pages.

                        Linus
