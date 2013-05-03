Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab3ECP1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:27:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48275 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759656Ab3ECP1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:27:34 -0400
Date: Fri, 3 May 2013 17:31:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, penberg@kernel.org,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130503153134.GD3433@pd.tnic>
References: <20130426095140.GA15361@pd.tnic>
 <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org>
 <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com>
 <5182AB66.6020307@linux.intel.com>
 <20130502194556.GB3553@gmail.com>
 <20130502200703.GE16684@pd.tnic>
 <20130503142900.GA3433@pd.tnic>
 <5183CFAC.8020005@infradead.org>
 <20130503150818.GC3433@pd.tnic>
 <5183D357.8000204@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5183D357.8000204@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 05:10:15PM +0200, Michal Marek wrote:
> You still risk that you miss some new dependency, but for a normal
> configs as a base, this won't be an issue in most cases. Whether this is
> implemented as a series of scripts/config calls or if there is a
> kvm_guest.config does not matter much, as long as randconfig does not
> see it ;).

Yep, I think we can do something along the lines of what hpa suggested:

* put a kvm_guest.config in arch/x86/configs/

* teach scripts/config/ to parse it and do set_var() for each line in
there.

* yes "" | make oldconfig - because we want to use the current config
as a base.

I think this is the easiest and cleanest of them all.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
