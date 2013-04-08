Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935269Ab3DHQnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:43:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60609 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761995Ab3DHQnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:43:09 -0400
Message-ID: <5162F390.5050701@wwwdotorg.org>
Date: Mon, 08 Apr 2013 10:42:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regmap: don't corrupt work buffer in _regmap_raw_write()
References: <1363820522-25954-1-git-send-email-swarren@wwwdotorg.org> <20130321190939.GI15926@opensource.wolfsonmicro.com> <1365416662.1830.86.camel@x61.thuisdomein> <20130408120059.GF9243@opensource.wolfsonmicro.com>
In-Reply-To: <20130408120059.GF9243@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 06:01 AM, Mark Brown wrote:
> On Mon, Apr 08, 2013 at 12:24:22PM +0200, Paul Bolle wrote:
> 
>> 0) This patch ended up as mainline commit 
>> bc8ce4afd7ee7e1421c935d24b1f879f82afdd4e, which is part of
>> v3.9-rc6.
> 
> Numbering your paragraphs and using full commit IDs like this
> doesn't help with legibility...
> 
>> 2) The following (draft) patch silences this warning. I'm a bit 
>> uncertain what the regmap_parse_*() functions are meant to do. So
>> I'd like to first ask whether something along these lines is
>> acceptable.
> 
> Nope, this breaks v3.9 - in that version they both modify in place
> and return the parsed value.  In v3.10 it already does what you
> have because the in place and return value versions have been
> split.
> 
> We need to either revert the commit from v3.9 on the basis that
> nobody noticed the issue until some other work so it can't be that
> bad or come up with a more invasive fix, at this point in the cycle
> I'm more inclined to do the latter.

I assume you mean "former" not "latter" above?

Revert might well be simplest and just fine. The issue this patch
fixes ended up getting accidentally "fixed" by the side-effects of
calling .parse_val() before commit 8a819ff "regmap: core: Split out in
place value parsing", and that commit only appears in 3.10, so we
should be able to revert this patch without issue in 3.9.
