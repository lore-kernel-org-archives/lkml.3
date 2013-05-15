Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab3EOOVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:21:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34684 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab3EOOVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:21:31 -0400
Date: Wed, 15 May 2013 16:21:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Victor Miasnikov <vvm@tut.by>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org, olaf@aepfle.de,
        "\"Andy Whitcroft\"" <apw@canonical.com>, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: CONFIG_HYPERVISOR_GUEST=y   {-- replace --
 CONFIG_PARAVIRT_GUEST=y {= { # CONFIG_HYPERVISOR_GUEST is not set } Re:
 3.10-rc1 Fw: [PATCH 2/2] x86: Make Linux guest support optional
Message-ID: <20130515142126.GA11783@pd.tnic>
References: <20130514160108.GA5055@dhcp22.suse.cz>
 <925E2E537ECB4D0C8EA18467A4D20174@local.st.by>
 <20130515133405.GC5455@dhcp22.suse.cz>
 <293D65E8F6CE48768FF47E438C57ECD2@local.st.by>
 <20130515134656.GF5455@dhcp22.suse.cz>
 <FC7F5007EF934194A48587DB6A0DBCC0@local.st.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <FC7F5007EF934194A48587DB6A0DBCC0@local.st.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 05:05:42PM +0300, Victor Miasnikov wrote:
> CONFIG_PARAVIRT_GUEST in arch/ia64 :
> 
> ./linux-3.10-rc1/arch/ia64/include/asm/native/
> inst.h
> ./linux-3.10-rc1/arch/ia64/configs/
> xen_domu_defconfig
> ./linux-3.10-rc1/arch/ia64/include/asm/
> hw_irq.h
> iosapic.h
> paravirt.h

This is only an issue if hyperv or vmware balloon is designed to work on
ia64.

However, both hyperv and vmware balloon depend on X86 so they are never
enabled on ia64.

So the way I see it, it doesn't matter.

Tony, what's your take on this - CONFIG_PARAVIRT_GUEST is
present in ia64 and I recently changed the Kconfig symbol to
CONFIG_HYPERVISOR_GUEST on x86. I can fix it for correctness but is
hyperv and vmware balloon even attempted on ia64?

Btw, it depends on BROKEN on ia64 so I'm already sceptical.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
