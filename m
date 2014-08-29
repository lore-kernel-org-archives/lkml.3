Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaH2PqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:46:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaH2PqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:46:22 -0400
Message-ID: <5400A04A.9000208@suse.de>
Date: Fri, 29 Aug 2014 17:46:18 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com> <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com> <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl> <53F5D8D9.7040604@suse.de> <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl> <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com> <20140825174610.GA13737@obsidianresearch.com> <53FB9AC4.8010704@gmail.com> <660fe929-1f16-4e22-8bd3-0388cd363978@BY2FFO11FD038.protection.gbl> <540099AF.4020005@suse.de> <e52ebd6c-2f0d-4ea9-a01f-882212956ace@BL2FFO11FD029.protection.gbl>
In-Reply-To: <e52ebd6c-2f0d-4ea9-a01f-882212956ace@BL2FFO11FD029.protection.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.08.2014 17:35, schrieb Sören Brinkmann:
> On Fri, 2014-08-29 at 05:18PM +0200, Andreas Färber wrote:
>> Am 29.08.2014 16:08, schrieb Michal Simek:
>>> I think resolution is:
>>> 1. Do not use marvell,88e1518 because it is not listed anywhere
>>> 2. Do not add ethernet-phy-idAAAA.BBBB because it breaks autodetection
>>> if there is different phy on the board and we shouldn't restrict us in this.
>>> In spite of autodetection takes some time.
>>> 3. "ethernet-phy-ieee802.3-c22" is optional that's why doesn't need to be added
>>> 4. Any listed compatible string has to be parsed which takes time
>>>
>>> That's why I think make sense not to use any compatible string.
>>> This should give us all flexibility which we want to have.
>>
>> Sorry, but we do need some node that we can reference via phy-handle
>> from the gem node, don't we?
>>
>> In that case, is not specifying any compatible string a valid option?
>>
>> If you don't want to specify the IDs, then I would've assumed we need to
>> specify the -c22 in order to have *some* compatible string in order to
>> trigger loading of the appropriate driver module.
> 
> The compatible string is listed as optional property for PHYs. So, not
> having one is an option, I guess. But, I'd also prefer to at least keep
> the -c22 one, since I saw problems when I tried using -c45 (the Zed phy
> should support it...).
> Also, so far, we haven't had any phy nodes in our Zynq dts files and
> Ethernet worked, so the auto-detection there works pretty well
> apparently. But it may be problematic if more than a single PHY is on
> the MDIO bus, I'd assume.

Hm, it didn't work for me initially, but maybe some config option was
missing in multi_v7 or something else. I'll re-test next week.

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
