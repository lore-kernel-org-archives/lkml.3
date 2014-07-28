Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaG1N4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:56:12 -0400
Received: from mailsec109.isp.belgacom.be ([195.238.20.105]:3966 "EHLO
	mailsec109.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbaG1N4J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:56:09 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=8GABNA2PKfBkI3TmnOEhvOPM8/Y8YqCipECynLqG0VI= c=1 sm=2
 a=GEYS01vQEFgA:10 a=IkcTkHD0fZMA:10 a=ag1SF4gXAAAA:8
 a=7tRksrRnffuVjH9avVUA:9 a=QEXdDO2ut3YA:10 a=1TSTQ8KKaH4A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0IAGNV1lPD7hTR/2dsb2JhbABZgw6BKYJ4rTgBAQEBAQEGoVyBNwGBDxZ3hAMBAQQBIwRSBQsFBAIYAgIYDgICVwYTEYgpDIpVnDCGf5ACF4EshFCJHTMHgnmBUQWnPohaggOBSDsv
Date: Mon, 28 Jul 2014 15:56:07 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Message-ID: <640430796.9897.1406555767987.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140724220254.GA26815@kroah.com>
References: <1406142278-21067-1-git-send-email-fabf@skynet.be> <20140724220254.GA26815@kroah.com>
Subject: Re: [PATCH 1/1 linux-next] staging: ion: vm_insert_pfn and
 zap_page_range rely on CONFIG_MMU
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 25 July 2014 at 00:02 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> wrote:
>
>
> On Wed, Jul 23, 2014 at 09:04:38PM +0200, Fabian Frederick wrote:
> > Fix following sh-allmodconfig errors reported on kisskb
> > "
> > drivers/built-in.o: In function `ion_vm_fault':
> > ion.c:(.text+0x1f2d8f8): undefined reference to `vm_insert_pfn'
> > drivers/built-in.o: In function `ion_buffer_sync_for_device':
> > ion.c:(.text+0x1f316bc): undefined reference to `zap_page_range'
> > make: *** [vmlinux] Error 1
> > "
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >
> > This is untested.
>
> I'd like to see it tested before I apply it...

Hello Greg,
       
        I did the following compilation tests:
       
        -sh/allyesconfig/cross-compile: no longer tries to compile ion with this
patch.
(MMU is only selected on !CPU_SH2 sub-type)

        -sh/SH-x3 subtype/cross-compile (->mmu on): compilation ok

        -x86_64 Compilation ok.
       
Do you need more testing ?

Regards,
Fabian
