Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3BDOCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:02:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53385 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab3BDOCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:02:14 -0500
Date: Mon, 4 Feb 2013 15:02:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: Re: [PATCH -v4 5/5] x86,smp: limit spinlock delay on virtual machines
Message-ID: <20130204140203.GB15452@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
	eric.dumazet@gmail.com, lwoodman@redhat.com, knoel@redhat.com,
	chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
	mingo@redhat.com
References: <20130125140553.060b8ced@annuminas.surriel.com>
 <20130125141917.6d5960a8@annuminas.surriel.com>
 <20130126120043.GB13445@gmail.com>
 <20130126124716.GB21395@pd.tnic>
 <510FBCA9.4070700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510FBCA9.4070700@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 08:50:33AM -0500, Rik van Riel wrote:
> We need to know whether we are actually running on top of a
> hypervisor, not whether we have the code compiled in to do so.

Oh ok, I see.

The thing is, if CONFIG_PARAVIRT_GUEST is disabled, x86_hyper won't
exist, see: http://marc.info/?l=linux-kernel&m=135936817627848&w=2

So maybe the hypervisor guest should itself take care of this and upon
init it should set the max_spinlock_delay in init_hypervisor() instead?
Seems only fair to me...

> After all, the majority of distribution kernels will have
> CONFIG_PARAVIRT_GUEST set, but the majority of those kernels
> will be running bare metal...

Yeah :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
