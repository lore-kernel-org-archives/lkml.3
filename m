Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3FEQuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:50:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46452 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab3FEQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:50:06 -0400
Message-ID: <51AF6C3A.5020609@wwwdotorg.org>
Date: Wed, 05 Jun 2013 10:50:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
CC: devicetree-discuss@lists.ozlabs.org,
        Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, jdl@jdl.com,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] dtc: ensure #line directives don't consume data from
 the next line
References: <1370273816-19411-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1370273816-19411-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 09:36 AM, Stephen Warren wrote:
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
> This is a port of upstream dtc commit a1ee6f0 (with same subject) to the
> kernel's copy of dtc.

Rob, Grant, does this look OK to apply for v3.10-rc*?
