Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3EaRmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:42:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40923 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3EaRmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:42:11 -0400
Message-ID: <51A8E0EE.1040305@wwwdotorg.org>
Date: Fri, 31 May 2013 11:42:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: David Gibson <david@gibson.dropbear.id.au>, jdl@jdl.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mmarek@suse.cz, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linux-kbuild@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] dtc: Ensure #line directives don't consume data from
 the next line
References: <1370020450-18136-1-git-send-email-swarren@wwwdotorg.org> <87sj13dp72.fsf@hase.home>
In-Reply-To: <87sj13dp72.fsf@hase.home>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 11:38 AM, Andreas Schwab wrote:
> Stephen Warren <swarren@wwwdotorg.org> writes:
> 
>> Fix this by replacing {WS} with [ \t] so that it can't match line-breaks.
> 
> I think the other uses of {WS} shouldn't span lines either.

That is true, but only the optional occurrence /should/ matter. Any
changes to the other occurrences would only affect malformed #line
directives, whereas changing this one occurrence would also affect
well-formed #line directives, due to the optional nature of the trailing
flags field.

Still, it may be reasonable just to change all the occurrences anyway.
Does anyone have a strong opinion either way?
