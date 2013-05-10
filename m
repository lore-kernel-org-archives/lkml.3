Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3EJPmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:42:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3EJPmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:42:17 -0400
Date: Fri, 10 May 2013 17:42:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
In-Reply-To: <CAFTL4hxx_pHkJExnRks4hcOYGrJb8TCMRdCtt0UA-i3wsaWWcQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1305101739030.23038@pobox.suse.cz>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130510002930.GB2394@somewhere> <20130510092811.GA22942@pd.tnic> <CAFTL4hxx_pHkJExnRks4hcOYGrJb8TCMRdCtt0UA-i3wsaWWcQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Frederic Weisbecker wrote:

> In fact it would be nice to have DO_ONCE(something) and stuff whatever
> we want inside.
> All the printk_once() et. al could even be implemented using that.

Sounds nice, but if it's going to be used for something else than purely 
debugging output, one has to keep in mind that printk_once() as currently 
implemented is actually racy.

I.e. you'd need to have locking (or at least cmpxchg) protecting the 
update of the static variable.

-- 
Jiri Kosina
SUSE Labs
