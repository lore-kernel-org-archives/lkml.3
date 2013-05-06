Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3EFQcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:32:09 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63935 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3EFQcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:32:07 -0400
Message-ID: <5187DB0C.2060605@gmail.com>
Date: Mon, 06 May 2013 18:32:12 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: regmap: Question about devices with unequal register sizes
References: <511FBBF7.2020103@gmail.com> <20130217162337.GB1583@opensource.wolfsonmicro.com>
In-Reply-To: <20130217162337.GB1583@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.02.2013 17:23, Mark Brown wrote:
> On Sat, Feb 16, 2013 at 06:03:51PM +0100, Daniel Mack wrote:
> 
>> The register layout is described on page 26, and they call their
>> registers 'subaddresses'. Up to sub-address 0x1c, I see no problem
>> mapping that to a simple 8-bit regmap layout, but above that, access
>> gets trickier because registers change their sizes, which breaks the cache.
> 
> The regmap I/O code isn't making any effort to support such devices, the
> hardware is just too crazy to worry about.  The best you can do is use
> the no-bus support and open code your physical I/O so you can still use
> the cache.

So it turns out I need to write these registers now on the TAS5086
codec, which has such a strange layout. I wonder how I can possibly open
code the physical I/O with registers that are up to 20 bytes in size,
while the reg_write callback in struct regmap_config assumes an unsigned
int suffices for the data? Any example you can point me to?


Thanks,
Daniel

