Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaHYMxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:53:13 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34302 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbaHYMxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:53:10 -0400
Date: Mon, 25 Aug 2014 13:53:06 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Harald Hoyer <harald@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
Message-ID: <20140825125306.GS29733@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <53F752A2.7080604@redhat.com>
 <CAPWNY8V4pfazk4Hw9qu07cAQZywC-GS7eyS+54fazXZaKMjMQw@mail.gmail.com>
 <CAPWNY8V=T=Y5uPX9J_qjdkTJRnctDs-PoTQP7LEX_cKQEn0_Zg@mail.gmail.com>
 <20140825105559.GQ29733@console-pimps.org>
 <CAPWNY8V8D74CNXGhDwp2gpPpeV2F=Qao32i-0Mhq=9zhvDXLLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPWNY8V8D74CNXGhDwp2gpPpeV2F=Qao32i-0Mhq=9zhvDXLLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug, at 02:08:59PM, Mantas Mikulėnas wrote:
> 
> Well, all I could find is:
> 
> > Freeing initrd memory: 5552K (ffff8800be22e000 - ffff8800be79a000)
> 
> Attaching the entire log.

Here we go,

> [    0.000000] RAMDISK: [mem 0xbe22e000-0xbe799fff]

OK, we're out of options here. Yinghai, we're going to have to revert
your patch, 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G")

We could conceivably add a boot parameter option to attempt loading
inirds above 4G, but we can't turn the feature on by default because of
all these buggy EFI implementations - things must work out of the box.

But the boot parameter would be useful for those people that a) know
their firmware isn't buggy and b) need to leave < 4G memory available
for use by other things. Yinghai, can you provide some justification for
your original commit? Do you have concrete use cases where loading
initrds above 4G is critical? How important is it that we enable this
functionality as opposed to reverting it?

It might also make sense to bump the default max initrd address
(hdr->initrd_addr_max) from 0x7fffffff to 0xffffffff at this point.
Peter, do you forsee any problem with this change?

-- 
Matt Fleming, Intel Open Source Technology Center
