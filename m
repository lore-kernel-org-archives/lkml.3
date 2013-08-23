Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3HWV6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:58:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33366 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3HWV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:58:41 -0400
Message-ID: <5217DB0C.7000101@wwwdotorg.org>
Date: Fri, 23 Aug 2013 15:58:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/5] spmi: add generic SPMI controller binding
 documentation
References: <cover.1377202730.git.joshc@codeaurora.org> <e42576b69ef3d4e624fbfa2f32f6f79a931b55d6.1377202730.git.joshc@codeaurora.org>
In-Reply-To: <e42576b69ef3d4e624fbfa2f32f6f79a931b55d6.1377202730.git.joshc@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 01:59 PM, Josh Cartwright wrote:
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
> I'm introducing this as an RFC, because there are set of assumptions
> made in this binding spec, that currently hold true for the supported
> controller/addressing scheme for the Snapdragon 800 series, but don't
> necessarily hold true for SPMI in general.
> 
>   1. No use of Group Slave Identifiers (GSIDs)
>      (SPMI allows for a slave to belong to zero or more groups specified
>      by GSID, however this feature isn't currently implemented)
> 
>   2. No specification of Master Identifier (MID)
>      (A "system integrator" allocates to each master a 2-bit MID, this
>      currently isn't being specified, as it isn't needed by software for
>      the PMIC Arb; not sure if this is of use to other SPMI controllers)
> 
>   3. Single SPMI master per controller
> 
> Effectively, only a subset of possible SPMI configurations are specified
> in this document.
> 
> So, if it's considered necessary to provide a generic SPMI binding
> specification, is it acceptable to only define a subset at this time,
> expanding only when necessary, or shall I expand the definition to at
> least address 1 & 2, even though they are of no use in the current
> implementation?

It's best to define the whole thing from the start if possible. It's
easier to ensure the whole binding is consistent, and nothing has been
left out.

However, it's probably OK to define a subset binding initially and then
expand it later, as long as some thought it put into how it can be
expanded in a way that is 100% compatible: old DTs will still operate
with new kernels and perhaps even new DTs will still operate with old
kernels.

That said, if the thought is put in to ensure that's possible, it's
probably just as easy to define the whole binding from the start.

