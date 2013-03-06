Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3CFA0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:26:33 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44553 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721Ab3CFA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:26:32 -0500
Date: Wed, 6 Mar 2013 00:26:15 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: proc: Add Krait proc info
Message-ID: <20130306002615.GA20530@mudshark.cambridge.arm.com>
References: <1362439299-29617-1-git-send-email-sboyd@codeaurora.org>
 <20130305083421.GA19391@mudshark.cambridge.arm.com>
 <51366B9E.7010502@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51366B9E.7010502@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 10:03:10PM +0000, Stephen Boyd wrote:
> On 03/05/13 00:34, Will Deacon wrote:
> > I was looking at this the other day and wondered whether we could set
> > HWCAP_IDIV in __v7_setup, depending on ID_ISAR0[27:24]. I can't immediately
> > think why that would be difficult, but similarly there may well be a reason
> > why we assign it like this.
> >
> > Fancy taking a look?
> 
> Ok I'll take a look. Should we be masking out HWCAP_IDIVT on
> !CONFIG_ARM_THUMB configurations?

Yes, that's not a bad idea. It makes the IDIV* caps follow what we do for
the others (vfp etc) by only advertising support if the relevant CONFIG
options are selected.

Will
