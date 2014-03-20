Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061AbaCTSUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:20:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54410 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaCTSUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:20:21 -0400
Message-ID: <532B3161.6080808@wwwdotorg.org>
Date: Thu, 20 Mar 2014 12:20:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Arun Shamanna Lakshmi <aruns@nvidia.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] ASoC: Add support for multi register mux
References: <1395186692-11735-1-git-send-email-aruns@nvidia.com> <20140318235941.GT11706@sirena.org.uk> <781A12BB53C15A4BB37291FDE08C03F3A05CB21E46@HQMAIL02.nvidia.com> <20140320114829.GC11706@sirena.org.uk>
In-Reply-To: <20140320114829.GC11706@sirena.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 05:48 AM, Mark Brown wrote:
> On Wed, Mar 19, 2014 at 04:44:00PM -0700, Arun Shamanna Lakshmi wrote:
> 
> Don't top post and fix your mailer to word wrap within paragraphs, your
> mail is very hard to read.
> 
>> If each bit of a 32 bit register maps to an input of a mux, then with
>> the current 'soc_enum' structure we cannot have more than 64 inputs
>> for the mux (because of reg and reg2 only).
> 
> What makes you say that?  We currently have devices in mainline which
> have well over 32 inputs to muxes.

I think their register layout is different.

I found a number of large muxes where the register stores a 'integer'
indicating which mux input to select, e.g. Arizona, WM2200, etc. In this
case, an N-bit register could support up to 2^N inputs.

However, the registers in the Tegra AHUB use 1 bit position per input,
and require you to set one single bit at a time. Hence, an N bit
register (or string of registers) can support up to N inputs. In more
recent Tegra chips, we have at least >32 inputs and I think Arun was
saying even >64 inputs. That requires 2 or 3 or more .reg fields in
struct soc_enum.
