Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3JDQZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:25:04 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:44156 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab3JDQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:25:01 -0400
Message-ID: <524EEB96.6040707@mm-sol.com>
Date: Fri, 04 Oct 2013 19:23:50 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Rob Herring <rob.herring@calxeda.com>,
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
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <20131003165130.GA11974@thunk.org>
In-Reply-To: <20131003165130.GA11974@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On 10/03/2013 07:51 PM, Theodore Ts'o wrote:
> On Thu, Oct 03, 2013 at 05:52:33PM +0300, Stanimir Varbanov wrote:
>> This patch set adds hardware RNG driver wich is used to control the
>> Qualcomm's PRNG hardware block.
>> The first patch document the DT bindings needed to sucessfuly probe
>> the driver and the second patch adds the driver.
> 
> Is this really a PRNG (pseudo-random number generator)?  What are the
> guarantees which Qualcomm is providing for the PRNG?  If it's really a
> PRNG such as AES(i++, NSA_KEY), then kudo to Qualcomm for being
> honest.
> 
> If it is supposed to be (or at least claimed to be) a secure random
> number generator ala RDRAND suitable for use in cryptographic
> applications, calling it a PRNG is going to be a bit misleading.

I guess that it should follow NIST 800-90 recommendation, but I'm not
aware what DRBG mechanism is used.

To be honest I really don't know the hardware implementation details. I
put PRNG abbreviation in the cover letter just because I saw that
defines for register offsets are prefixed with PRNG_*. I could rename
all occurrences of PRNG to RNG. Is that will be enough to avoid confusions?

regadrs,
Stan
