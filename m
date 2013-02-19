Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab3BSRfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:35:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52528 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807Ab3BSRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:35:04 -0500
Message-ID: <5123B7C4.9030002@wwwdotorg.org>
Date: Tue, 19 Feb 2013 10:35:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] ARM: dt: add header to define tegra20 clocks
References: <1360791198-29462-1-git-send-email-swarren@wwwdotorg.org> <1360823899-17846-1-git-send-email-hdoyu@nvidia.com> <511D24D4.6070805@wwwdotorg.org> <20130219053148.GC3108@S2101-09.ap.freescale.net>
In-Reply-To: <20130219053148.GC3108@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 10:31 PM, Shawn Guo wrote:
> On Thu, Feb 14, 2013 at 10:54:28AM -0700, Stephen Warren wrote:
>> On 02/13/2013 11:38 PM, Hiroshi Doyu wrote:
>>> To replace magic number in "clocks = <&tegra_car 28>;"
>>
>> I like the concept here; I was thinking about doing this today, but you
>> beat me to it:-) Feel free to create the Tegra30 header too, and modify
>> all the *.dts* files.
>>
>> To address other comments in this thread: Yes, I think that we will want
>> to modify the clock driver to include this header to avoid
>> duplication/errors (that will require adjusting Linux's include path),
>> and also remove the list of IDs from the binding document; it can just
>> refer the the new header by name and cause the header to *be* part of
>> the binding document.
> 
> I like it, since doing so will help us hijack kernel to have dts stay
> in the tree rather than going to a separate repository :)

Well, at least the header files would need to stay in the kernel. The
.txt binding documentation wouldn't have to though.

I guess this is a good argument for not putting these header files into
Documentation/devicetree/bindings, and adding that to the include path,
but rather putting the headers somewhere else.

> Seriously, is maintaining dts in a separate repository still a plan?
> If yes, we will have duplication problem someday anyway.
> 
> For reason of it, I vote for having dts stay in the kernel tree.
> 
> Shawn
> 

