Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3FEMoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:44:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3FEMox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:44:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, Ian.Campbell@citrix.com,
        catalin.marinas@arm.com, konrad.wilk@oracle.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 5/6] arm64/xen: introduce CONFIG_XEN and hypercall.S on ARM64
Date: Wed, 05 Jun 2013 14:44:55 +0200
Message-ID: <1471793.18ZhhAHKN9@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com> <1370434530-22428-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nOlBtCllwtaVt4gYjm0TwN/k2QnnYWxNCN9NC5q46SH
 yYWW0iXJoeukv2NMkSjzZEruoJN4OAyQOBXaKsJR2+yJlT8M7x
 lHxzjhqp3g0mmDvR4Q+M/SWX1KnyeOcYqLBwlej8MGyB0tqPlp
 3Sw3EgbejlmECM6Jks/1J/seV7Ws5NgPXJguXljrRtZ3wlGMUG
 +cTJo2YXorXzs4dLqU0AN7WXRiS3UsVoC7Suoi98sMD2PFsSJs
 FZjrWH0iHbbOEgH4QVSvXusDNo/2gwBBuuvU5Rgrwf8s3z2zlf
 jQpSMlS9fgtwF7GydBJzKMTDfGWKVLv/jT8/9BSGdiy2TdiG1B
 yrtTT0KhgQfN7tIlviyY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 June 2013 13:15:29 Stefano Stabellini wrote:
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index c95c5cb..79dd13d 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -37,6 +37,7 @@ TEXT_OFFSET := 0x00080000
>  export TEXT_OFFSET GZFLAGS
>  
>  core-y         += arch/arm64/kernel/ arch/arm64/mm/
> +core-$(CONFIG_XEN)             += arch/arm64/xen/
>  libs-y         := arch/arm64/lib/ $(libs-y)
>  libs-y         += $(LIBGCC)
>  
> diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
> new file mode 100644
> index 0000000..be24040
> --- /dev/null
> +++ b/arch/arm64/xen/Makefile
> @@ -0,0 +1,2 @@
> +xen-arm-y      += $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
> +obj-y          := xen-arm.o hypercall.o

I think it would be nicer to redirect the entire directory, not just
the enlighten.o and grant-table.o files. You could do in arch/arm64/Makefile:

core-(CONFIG_XEN) += arch/arm/xen/

That leaves a small difference in hypercall.o, which I think you can
handle with an #ifdef.

I believe the reason why KVM does the more elaborate variant is that
they want to be able to build their code as a loadable module that
also includes code from virt/kvm, which you don't need.

	Arnd
