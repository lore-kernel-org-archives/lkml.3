Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaK0Qgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:36:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaK0Qgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:36:46 -0500
Date: Thu, 27 Nov 2014 17:36:39 +0100
From: Borislav Petkov <bp@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, david.vrabel@citrix.com,
        stable@vger.kernel.org, rshendershot@mchsi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141127163639.GJ4828@pd.tnic>
References: <b4d424e6-81b2-4b21-ab2f-3d403a455f57@default>
 <20141127091228.GA4828@pd.tnic>
 <20141127162118.GA24829@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141127162118.GA24829@konrad-lan.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:21:19AM -0500, Konrad Rzeszutek Wilk wrote:
> > Ok, but let's have a clean design: maybe have a weak default stub which
> > returns false when PARAVIRT is not enabled in the .config and then add
> > an override in, say, arch/x86/kernel/paravirt.c which returns true when
> > running as a guest. Something like that, at least.
> 
> You are describing 'paravirt_enabled()' :-)

Haha.

Although I have a suspicion this won't work either because we're loading
microcode very early on 32-bit, before paging has been enabled, and
accessing pv_info.paravirt_enabled will probably go boom. AFAICT, from a
quick glance.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
