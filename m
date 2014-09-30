Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaI3Uj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:39:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52386 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaI3Uj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:39:27 -0400
Message-ID: <542B14FC.60007@ti.com>
Date: Tue, 30 Sep 2014 15:39:24 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] regmap: Allow read_reg_mask to be 0
References: <1412093220-24690-1-git-send-email-dmurphy@ti.com> <20140930172543.GG4273@sirena.org.uk>
In-Reply-To: <20140930172543.GG4273@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark

Thanks for the quick review

On 09/30/2014 12:25 PM, Mark Brown wrote:
> On Tue, Sep 30, 2014 at 11:07:00AM -0500, Dan Murphy wrote:
>
>> -	if (config->read_flag_mask || config->write_flag_mask) {
>> +	if (config->read_flag_mask == REGMAP_NO_READ_MASK)
>> +		map->read_flag_mask = 0x00;
>> +	else if (config->read_flag_mask)
> This breaks the symmetry in handling of read and write masks which isn't
> great, please make the equivalent update for the write mask too.
>
>
Hmmm.  If I make the similar change for the write mask I will be adding dead
code as write_flag_mask is not defaulted by the bus like the read_flag_mask which is
defaulted to 0x80 in the regmap-spi code.  The i2c code does not make this assumption.

The original code did not seem to have symmetry as the only instance
that write_flag_mask is modified is if it is non-zero.

Let me know what you think.  I can add the code to make it more symmetrical but
we may be adding code that is dead.  If I remove the defaulted read_flag_mask value out
of the spi driver then I will need to find every spi device that needs that flag and set it.
IMHO that would be really messy and probably mess us some drivers.

>> +#define REGMAP_NO_READ_MASK		0xff
> An actual out of band value might be preferable here though that'd
> involve changing the type and more checking so perhaps inessential.

Thought about making this -1 with a variable change but that seemed
really drastic where a value of 0xff seems to be a value that no one should use.

Dan

-- 
------------------
Dan Murphy

