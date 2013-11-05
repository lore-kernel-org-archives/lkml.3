Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3KEWqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:46:53 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:36183 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab3KEWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:46:52 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1382698313-13161-16-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
	<1382698313-13161-16-git-send-email-stefano.stabellini@eu.citrix.com>
Date: Tue, 5 Nov 2013 14:46:51 -0800
Message-ID: <CAOesGMjdfGoEp+yCRa1WhQi=c_LHBCjrU3H9WUqf0Fn_cqkz_Q@mail.gmail.com>
Subject: Re: [PATCH v9 16/18] arm,arm64: do not always merge biovec if we are
 running on Xen
From: Olof Johansson <olof@lixom.net>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        konrad.wilk@oracle.com, Ian Campbell <Ian.Campbell@citrix.com>,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 25, 2013 at 3:51 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> This is similar to what it is done on X86: biovecs are prevented from merging
> otherwise every dma requests would be forced to bounce on the swiotlb buffer.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>


This is spewing 800+ warnings on ape6evm_defconfig on ARM that doesn't
have CONFIG_BLOCK enabled, since struct bio_vec is protected by that
in include/linux/blk_types.h. I guess it could be argued that those
ifdefs could be removed, but still:

../../arch/arm/include/asm/io.h:378:24: warning: its scope is only
this definition or declaration, which is probably not what you want
[enabled by default]
In file included from ../../include/linux/scatterlist.h:10:0,
                 from ../../include/linux/dmaengine.h:27,
                 from ../../include/linux/skbuff.h:31,
                 from ../../include/crypto/algapi.h:18,
                 from ../../crypto/internal.h:16,
                 from ../../crypto/cipher.c:21:
../../arch/arm/include/asm/io.h:378:24: warning: 'struct bio_vec'
declared inside parameter list [enabled by default]
           const struct bio_vec *vec2);


-Olof
