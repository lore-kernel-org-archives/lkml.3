Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab3FCNdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:33:06 -0400
Received: from jdl.com ([208.123.74.7]:45576 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755Ab3FCNdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:33:05 -0400
Message-Id: <E1UjUsY-0008Td-Bj@jdl.com>
To: Stephen Warren <swarren@wwwdotorg.org>
cc: David Gibson <david@gibson.dropbear.id.au>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mmarek@suse.cz, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linux-kbuild@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] dtc: ensure #line directives don't consume data from the next line
In-reply-to: <1370025184-23808-1-git-send-email-swarren@wwwdotorg.org>
References: <1370025184-23808-1-git-send-email-swarren@wwwdotorg.org>
Comments: In-reply-to Stephen Warren <swarren@wwwdotorg.org>
   message dated "Fri, 31 May 2013 12:33:04 -0600."
Date: Mon, 03 Jun 2013 08:32:54 -0500
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: 0.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Warren <swarren@nvidia.com>
> 
> Previously, the #line parsing regex ended with ({WS}+[0-9]+)?. The {WS}
> could match line-break characters. If the #line directive did not contain
> the optional flags field at the end, this could cause any integer data on
> the next line to be consumed as part of the #line directive parsing. This
> could cause syntax errors (i.e. #line parsing consuming the leading 0
> from a hex literal 0x1234, leaving x1234 to be parsed as cell data,
> which is a syntax error), or invalid compilation results (i.e. simply
> consuming literal 1234 as part of the #line processing, thus removing it
> from the cell data).
> 
> Fix this by replacing {WS} with [ \t] so that it can't match line-breaks.
> 
> Convert all instances of {WS}, even though the other instances should be
> irrelevant for any well-formed #line directive. This is done for
> consistency and ultimate safety.
> 
> Reported-by: Ian Campbell <Ian.Campbell@citrix.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Convert all instances of {WS} in the regex.

Applied.

Thanks!

jdl
