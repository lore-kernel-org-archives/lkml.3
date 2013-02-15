Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936001Ab3BOQDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:03:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35025 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab3BOQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:03:09 -0500
Date: Fri, 15 Feb 2013 17:02:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 07/13] edac: add support for raw error reports
Message-ID: <20130215160257.GK14387@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1360931635.git.mchehab@redhat.com>
 <e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
 <20130215141330.GF14387@pd.tnic>
 <20130215132530.4f3b7dab@redhat.com>
 <20130215154123.GH14387@pd.tnic>
 <20130215134929.3909cfa2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130215134929.3909cfa2@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 01:49:29PM -0200, Mauro Carvalho Chehab wrote:
> Sure, but calling kmalloc while handling a memory error doesn't seem
> a very good idea, IMHO. So, better to either use an already allocated
> space (or the stack).

Either that, or prealloc a buffer on EDAC initialization. You probably
won't need more than one in 99% of the cases so if you keep it simple
with a single static buffer for starters, that would probably be the
cleanest solution.

> Yes, I know, but, on the other hand, there's the additional cost of
> copying almost all data into the structure.

That's very easily paralelizable on out-of-order CPUs (I'd say, all of
them which need to run EDAC, can do that :-)) so it wouldn't hurt.

Also, you could allocate the struct in the callers and work directly
with its members before sending it down to edac_raw_mc_handle_error() -
that would probably simplify the code a bit more.

> Ok, I'll keep this patch on my git. I'll likely fold it with the
> previous one on the final patchset.

Yep.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
