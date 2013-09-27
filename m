Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3I0Pc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:32:57 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:58922 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3I0Pcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:32:53 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5rHSweG2GBQ=
X-RZG-CLASS-ID: mo00
Date: Fri, 27 Sep 2013 17:32:43 +0200
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Message-ID: <20130927153242.GA29462@aepfle.de>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <20130927151026.GA29416@aepfle.de>
 <418dd0e9b1054189b61770edb57c5b37@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <418dd0e9b1054189b61770edb57c5b37@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, KY Srinivasan wrote:

> > This leads to build errors on 32bit:
> > 
> > linux-3.12-rc2/arch/x86/kernel/cpu/mshyperv.c:88: undefined reference to
> > `__udivdi3'
> > 
> > Up to now I have only tested on 64bit, sorry for that.
> 
> Thanks Olaf. I am travelling currently; I will fix it when I get back (early next week).

This change seems to fix it:

-+              hv_lapic_frequency /= HZ;
++              div_u64(hv_lapic_frequency, HZ);

Olaf
