Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967087AbaFROa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:30:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43478 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966703AbaFROaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:30:52 -0400
X-IronPort-AV: E=Sophos;i="5.01,501,1400025600"; 
   d="scan'208";a="144622490"
Date: Wed, 18 Jun 2014 15:30:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Matt Fleming <matt@console-pimps.org>,
        Daniel Kiper <daniel.kiper@oracle.com>, <andrew.cooper3@citrix.com>,
        <david.vrabel@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <matt.fleming@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, <eshelton@pobox.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
In-Reply-To: <53A1B726020000780001B6CF@mail.emea.novell.com>
Message-ID: <alpine.DEB.2.02.1406181523340.13771@kaball.uk.xensource.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com> <20140618135229.GH24049@console-pimps.org> <53A1B726020000780001B6CF@mail.emea.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Jan Beulich wrote:
> >>> On 18.06.14 at 15:52, <matt@console-pimps.org> wrote:
> > EFI_PARAVIRT will be usable by architectures other than x86, correct? If
> > your intention is for it only ever to be used by x86, then it should
> > probably be EFI_ARCH_2.
> 
> I would expect ARM, once it gets UEFI support on the Xen side, to
> be able to handle most of this identically to x86. Which raises the
> question whether most of the new Xen-specific code (in one of the
> other patches) wouldn't better live under drivers/xen/.

I was thinking the same thing.

However this patch series doesn't add much code outside
drivers/xen/efi.c and include/xen/interface/platform.h.
I think it wouldn't be fair to ask Daniel to refactor the efi code
currently under arch/x86 to an arch-independent location.
Whoever comes in later and adds EFI Xen support for ARM can do that.
