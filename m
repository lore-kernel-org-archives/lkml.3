Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab3EONeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:34:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758945Ab3EONeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:34:07 -0400
Date: Wed, 15 May 2013 15:34:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Victor Miasnikov <vvm@tut.by>
Cc: Borislav Petkov <bp@alien8.de>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org, olaf@aepfle.de,
        "\"Andy Whitcroft\"" <apw@canonical.com>, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com
Subject: Re: CONFIG_HYPERVISOR_GUEST=y   {-- replace --
 CONFIG_PARAVIRT_GUEST=y {= { # CONFIG_HYPERVISOR_GUEST is not set } Re:
 3.10-rc1 system starts regular boot when waking from s2ram Fw: [PATCH 2/2]
 x86: Make Linux guest support optional
Message-ID: <20130515133405.GC5455@dhcp22.suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz>
 <925E2E537ECB4D0C8EA18467A4D20174@local.st.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <925E2E537ECB4D0C8EA18467A4D20174@local.st.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-05-13 16:17:09, Victor Miasnikov wrote:
> Hi!
> 
> b)
> 
> See in P.S.
> CONFIG_PARAVIRT_GUEST in arch/ia64
> 
> a)
> config-3.10.0-rc1-fullnohzdisabled
> ==
> # CONFIG_HYPERVISOR_GUEST is not set
> ==
> 
> >- select PARAVIRT_GUEST
> >+ select HYPERVISOR_GUEST

I might have missed the previous discussion but how does this relate to
the original problem reported to this (https://lkml.org/lkml/2013/5/14/398)
thread?

I have bisected to the faulty patch and reverting it proved to help
(https://lkml.org/lkml/2013/5/15/160)

For record:
$grep HYPERVISOR_GUEST .config
# CONFIG_HYPERVISOR_GUEST is not set
$grep PARAVIRT_GUEST .config
$

[...]
-- 
Michal Hocko
SUSE Labs
