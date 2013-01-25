Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3AYIs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:48:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39971 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3AYIs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:48:57 -0500
Date: Fri, 25 Jan 2013 09:51:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/2] x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt
 menu
Message-ID: <20130125085146.GA23404@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	X86 ML <x86@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
	olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
	Borislav Petkov <bp@suse.de>
References: <20130124173555.GJ13463@pd.tnic>
 <1359049194-17505-1-git-send-email-bp@alien8.de>
 <20130125082126.GD25314@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130125082126.GD25314@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 09:21:26AM +0100, Ingo Molnar wrote:
> 
> So, these two patches, on top of -tip, produce:
> 
> vmw_balloon.c:(.init.text+0x8506): undefined reference to `x86_hyper'
> vmw_balloon.c:(.init.text+0x850a): undefined reference to `x86_hyper_vmware'

Hmm, I somehow can't trigger it here. And the thing is, vmw_balloon.c is
built only when CONFIG_VMWARE_BALLOON is set and that is not the case in
this config.

[ … ]

> CONFIG_HMC6352=y
> # CONFIG_DS1682 is not set
> # CONFIG_VMWARE_BALLOON is not set

But still, I can see how this can still trigger because code is assuming
the presence of x86_hyper which those patches don't guarantee anymore. I
still haven't sorted out through my test builds here, will do so now and
check.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
