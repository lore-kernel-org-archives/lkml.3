Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbaDKNO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:14:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38561 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbaDKNOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:14:51 -0400
Date: Fri, 11 Apr 2014 15:14:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Punnaiah Choudary <kpc528@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Doug Thompson <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        punnaiah choudary kalluri <punnaia@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
Message-ID: <20140411131442.GA11636@pd.tnic>
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com>
 <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
 <20140409113246.GA8778@pd.tnic>
 <CAL_Jsq+gszc+R_BrLtHKEBGYd=3T+sE1d+-HoF9aYZt6C2k5-g@mail.gmail.com>
 <20140409151932.GK6529@pd.tnic>
 <CAHLkNHJTA5bGD1zAfzE2JrDFAWvmgYyYjir+4vR-d9Fe2-E48g@mail.gmail.com>
 <20140409174701.GO6529@pd.tnic>
 <53463641.1030800@monstr.eu>
 <20140410090246.GC29093@pd.tnic>
 <53466DBF.7030606@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53466DBF.7030606@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 12:09:03PM +0200, Michal Simek wrote:
> The question here is. This driver is just reporting problem through
> edac interface which is counting that errors and provide an unified
> way how to report problems.

Yes, normally you can use edac for reporting and error counting. But,
if, as I said earlier, it is easier to solve your issue of having two
entities touch one hardware and synchronizing around it is too much,
just for this one case, you can simply report the errors with simple
printk, without the edac interface.

This is why I was asking the practical question of why do you even need
the edac interface? If it is only for reporting, use printk and solve
the problem of having two drivers.

> Maybe as you said we don't need to use edac interface at all but by
> design because every error means that there is the problem and error
> should be reported and system should be reset because we just don't
> know where the problem is. We know that we have a problem.
>
> The question also is if we should execute any code because the problem
> can be with instructions and system should just reset.
>
> Isn't there any security issue that even executing any code is a
> problem?

Well, this is up to you to answer. If an UE (Uncorrectable Error) causes
data to get corrupted on your system, which, as a result, corrupts
visible state which lands on storage, you definitely want to stop
executing any code. x86 deals very rigorously with errors like those
by running an exception handler, on AMD there's also this thing called
syncflood which stops any execution and a warm reset happens.

So you have to think hard what those UEs cause on your systems and only
then act accordingly. If something bad like the above happens, the last
thing you want to do is report them to dmesg.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
