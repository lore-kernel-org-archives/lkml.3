Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3EHJHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 05:07:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342Ab3EHJHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 05:07:16 -0400
Date: Wed, 8 May 2013 10:06:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ARM: Remove any correlation between IPC and
 BogoMips value
Message-ID: <20130508090644.GA15692@mudshark.cambridge.arm.com>
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
 <5187EFF3.6010005@codeaurora.org>
 <20130507090849.GC25387@mudshark.cambridge.arm.com>
 <5189224A.70501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5189224A.70501@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christopher,

On Tue, May 07, 2013 at 04:48:26PM +0100, Christopher Covington wrote:
> On 05/07/2013 05:08 AM, Will Deacon wrote:
> > That seems like a lot of effort in order to preserve something that isn't
> > even meaningful. We might be better just zeroing the value, but then we'll
> > inevitably get bug reports of it being `wrong'.
> 
> If I were in to filing bug reports about bogomips values, I would be just as
> likely to do it for 1, 10000, 99999, and get_random_bytes(...) as for 0.

That's a fair point, and one of the reasons I posted this as an RFC. I'd
basically like an `obviously bogus' value so that people don't think `hey,
my CPU sure it slow' and instead think `looks like this really is a bogus
value after all'.

However, you're probably right that there isn't a number which can convey
that information properly, so how about we just put a string in there along
the lines of "not reported" and leave it at that?

Will
