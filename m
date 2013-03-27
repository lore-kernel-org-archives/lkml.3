Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3C0SDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:03:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3C0SDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:03:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
Date: Wed, 27 Mar 2013 18:03:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1303271642340.4430@kaball.uk.xensource.com> <51533037.5060004@gmail.com>
In-Reply-To: <51533037.5060004@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303271803.45420.arnd@arndb.de>
X-Provags-ID: V02:K0:0v1A/Qk6OiaupqAgjVkA+PGxJXNrpAZFpaNJo63Hooe
 NbmvfXdk1MNnjPaUMN06pPrnI45Tz0cf3xBIlhkmdxujfb8VBZ
 L852FFZHbl8TIgI7gfhtI6rhNbQw3IV3q9zS3VWLE7gJcjDuHO
 K5iyREYQlrlJTi4NnCqDrHZrqQI1ftUEoVvLs4Z1EnKGNg6XKA
 yqDy05acOC+Ccp4QH8A7KMyHnMKoKH5XDCCKPgKnZ730ORyznP
 feNrhSG/CRBsUvj+E9QsFP0lVApVmjlxccelz/I8IZ/sRvCOlb
 vx7CfIG/VD5g/a3k20gcgvRPGvMTocfluPFiDE3yg8bV9BturR
 C9sh621uM9aX/8I3PewY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 March 2013, Rob Herring wrote:
> No, I was thinking in the case of Xen and mach-virt, you would not set
> mdesc->smp. So you would have something like this:
> 
> if (mdesc->smp)
>         smp_set_ops(mdesc->smp);
> else
>         smp_set_ops(&psci_smp_ops);

The case that Stefano is interested in if obviously other platforms
that can either run as Dom0 under Xen with psci_smp_ops or natively
with their own smp_ops. A similar case would be a platform that
may implement psci using smc when run in secure mode but provide
its own smp_ops when run natively.

In both cases, it would be simpler to use psci if available but
fall back to mdesc->smp otherwise.

	Arnd
