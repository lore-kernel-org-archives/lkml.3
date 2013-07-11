Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3GKNBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:01:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:35188 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab3GKNBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:01:11 -0400
Message-ID: <1373545982.19894.82.camel@pasglop>
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 11 Jul 2013 22:33:02 +1000
In-Reply-To: <51DE3ECB.7080803@ozlabs.ru>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
	 <1373123227-22969-7-git-send-email-aik@ozlabs.ru>
	 <51DC4228.7010607@suse.de> <51DCEA76.9070808@ozlabs.ru>
	 <D10E7B99-3A7C-4275-9A49-3CB15598E705@suse.de> <51DE3ECB.7080803@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 15:12 +1000, Alexey Kardashevskiy wrote:
> >> Any debug code is prohibited? Ok, I'll remove.
> > 
> > Debug code that requires code changes is prohibited, yes.
> > Debug code that is runtime switchable (pr_debug, trace points, etc)
> > are allowed.

Bollox.

$ grep DBG\( arch/powerpc/ -r | wc -l
418

Also pr_devel is not runtime switchable in normal kernels either and
still an "official" kernel interface.

> Is there any easy way to enable just this specific udbg_printf (not all of
> them at once)? Trace points do not work in real mode as we figured out.

The cleaner way to do it is to use some kind of local macro that you
enable/disable by changing a #define at the top of the function, possibly
several.

Cheers,
Ben.


