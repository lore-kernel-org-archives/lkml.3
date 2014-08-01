Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbaHAJCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:02:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45742 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaHAJCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:02:31 -0400
Date: Fri, 1 Aug 2014 11:02:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, pbonzini@redhat.com,
        kvm@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH 1/2] x86: AMD: mark TSC unstable on APU family 15h models
 10h-1fh
Message-ID: <20140801090228.GA3924@nazgul.tnic>
References: <1406800033-13404-1-git-send-email-imammedo@redhat.com>
 <1406800033-13404-2-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406800033-13404-2-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:47:12AM +0000, Igor Mammedov wrote:
> Due to erratum #778 from
> "Revision Guide for AMD Family 15h Models 10h-1Fh Processors,
>  Publication # 48931, Issue Date: May 2013, Revision: 3.10"
> 
> TSC on affected processor, a core may drift under certain conditions,
> which makes initially synchronized TSCs to become unsynchronized.
> 
> As result TSC clocksource becomes unsuitable for using as wallclock
> and it brakes pvclock when it's running with PVCLOCK_TSC_STABLE_BIT
> flag set.
> That causes backwards clock jumps when pvclock is first read on
> CPU with drifted TSC and then on CPU where TSC was stable or had
> a lower drift rate.
> 
> To fix issue mark TSC as unstable on affected CPU, so it won't
> be used as clocksource. Which in turn disables master_clock
> mechanism in KVM and force pvclock using global clock counter
> that can't go backwards.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

Acked-by: Borislav Petkov <bp@suse.de>
