Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3FZRMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:12:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60551 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299Ab3FZRMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:12:22 -0400
Date: Wed, 26 Jun 2013 18:11:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Add support for LPAE style CONTEXTIDR
Message-ID: <20130626171138.GF10333@mudshark.cambridge.arm.com>
References: <1372080405-13365-1-git-send-email-cov@codeaurora.org>
 <20130624140424.GA24861@mudshark.cambridge.arm.com>
 <51C85A0D.3070400@codeaurora.org>
 <20130624145303.GA25582@mudshark.cambridge.arm.com>
 <51C8627A.5000106@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C8627A.5000106@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:15:06PM +0100, Christopher Covington wrote:
> On 06/24/2013 10:53 AM, Will Deacon wrote:
> > On Mon, Jun 24, 2013 at 03:39:09PM +0100, Christopher Covington wrote:
> >> Hi Will,
> >>
> >> On 06/24/2013 10:04 AM, Will Deacon wrote:
> >> [...]
> >>
> >>> What's the advantage of this approach, other than you get an extra byte's
> >>> worth of PID?
> >>
> >> In my view, the real advantage is that the the PID is located where people
> >> reading ARM Architecture Reference Manual are told they can find it.
> > 
> > Perhaps, but I'd usually expect a debugger or trace tools to do something
> > with the PID, and they likely expect it to be shifted, so you can't really
> > win.
> 
> But reading and implementing the architecture *is* winning! LOL. I'll file a
> ticket with the architecture folks and see what they think.

...aaand that came full circle :)

I think the conclusion is that Linux PID != CONTEXTIDR.PROCID, so there's no
architectural issue here. I'm just trying to keep it easy for the tools.

Will
