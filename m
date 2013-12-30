Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3L3TWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 14:22:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab3L3TWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 14:22:35 -0500
Message-ID: <1388431259.2564.15.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64/xen: redefine xen_remap on arm64
From: Mark Salter <msalter@redhat.com>
To: Chen Baozi <baozich@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
        catalin.marinas@arm.com, stefano.stabellini@eu.citrix.com,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Dec 2013 14:20:59 -0500
In-Reply-To: <1388386511-32276-1-git-send-email-baozich@gmail.com>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-30 at 14:55 +0800, Chen Baozi wrote:
> xen_remap used to be defined as ioremap_cached on arm64. In commit
> c04e8e2fe, a new ioremap_cache was implemented, and ioremap_cached
> was deleted, while xen_remap stays the same. This would lead to
> the failure when building with CONFIG_HVC_XEN. Redefined xen_remap
> on arm64 as ioremap_cache on arm64 to fix it.
> 

I missed that include of arm header by arm64 when looking for users
of arm64's ioremap_cached() when working on commit c04e8e2fe. Anyway,
grepping the kernel tree, I see:

  ioremap_cached()
    defined by: arm, metag, unicore32
    used by: arch/arm/include/asm/xen/page.h
             drivers/mtd/maps/pxa2xx-flash.c

  ioremap_cache()
    defined by: arm64, sh, xtensa, ia64, x86
    used by: drivers/video/vesafb.c
             drivers/char/toshiba.c
             drivers/acpi/apei
             drivers/lguest/lguest_device.c
             drivers/sfi/sfi_core.c
             include/linux/acpi_io.h

I think it would be better to just avoid the confusion and the ifdef in
asm/xen/page.h by globally changing ioremap_cached to ioremap_cache.

--Mark


