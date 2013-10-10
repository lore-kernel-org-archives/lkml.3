Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3JJNtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:49:03 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:56929 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab3JJNtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:49:00 -0400
Message-ID: <5256AFFE.5090605@mm-sol.com>
Date: Thu, 10 Oct 2013 16:47:42 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Qualcomm's PRNG
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <20131003165130.GA11974@thunk.org> <524EEB96.6040707@mm-sol.com> <20131004181005.GA7022@thunk.org> <52556C4E.9000604@mm-sol.com> <52557137.5050200@zytor.com>
In-Reply-To: <52557137.5050200@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, Peter,

On 10/09/2013 06:07 PM, H. Peter Anvin wrote:
> On 10/09/2013 07:46 AM, Stanimir Varbanov wrote:
>>
>> No, there is no public documentation for the block. Here is the driver
>> documentation which I used as a base [1].
>>
>> My guess was that - if it is PRNG (got from hardware description link
>> above) than according to wiki [2] it is also known as a deterministic
>> random bit generator (DRBG). The recommendation for RNG using DRBG is
>> NIST 800-90.
>>
>> Of course I could be wrong, so I can add a comment that this is just a
>> guess and we shouldn't over-reliance on this.
>>
> 
> There needs to be an architecturally guaranteed lower bound on the
> entropic content for this to be at all useful.  However, the hwrandom
> interface is currently expecting fully entropic output (which is almost
> certainly bogus... consider the PowerPC random number generator[1]) and
> so using it for a PRNG output is directly wrong.  This is part of why
> RDRAND support is implemented directly in rngd so that we can do the
> required cryptographic data reduction to produce fully entropic output.

I ran the rngtest with following command line:

# cat /dev/hw_random | rngtest -c 100000

Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 2000000032
rngtest: FIPS 140-2 successes: 99925
rngtest: FIPS 140-2 failures: 75
rngtest: FIPS 140-2(2001-10-10) Monobit: 10
rngtest: FIPS 140-2(2001-10-10) Poker: 9
rngtest: FIPS 140-2(2001-10-10) Runs: 20
rngtest: FIPS 140-2(2001-10-10) Long run: 38
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=1.267; avg=53.222; max=2384.186)Mibits/s
rngtest: FIPS tests speed: (min=3.016; avg=48.847; max=49.931)Mibits/s
rngtest: Program run time: 75191914 microseconds

Could you guys comment those results?

regards,
Stan

