Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaISBkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:40:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57120 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbaISBkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:40:35 -0400
Date: Fri, 19 Sep 2014 02:40:01 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] arm: vfp: Bounce undefined instructions in vectored
 mode
Message-ID: <20140919014001.GB20773@arm.com>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
 <1411076592-6157-4-git-send-email-sboyd@codeaurora.org>
 <20140918225531.GG5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918225531.GG5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:55:31PM +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 18, 2014 at 02:43:12PM -0700, Stephen Boyd wrote:
> > From: Stepan Moskovchenko <stepanm@codeaurora.org>
> > 
> > Certain ARM CPU implementations (e.g. Cortex-A15) may not raise a
> > floating- point exception whenever deprecated short-vector VFP
> > instructions are executed. Instead these instructions are treated
> > as UNALLOCATED. Change the VFP exception handling code to emulate
> > short-vector instructions even if FPEXC exception bits are not
> > set.
> 
> Purely out of interest, how much use do these instructions have in
> real programs?

They're seldom used, but there are apps in the app store that use short
vectors to play music.

Will
