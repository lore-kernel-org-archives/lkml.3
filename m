Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaFRSW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:22:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37542 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaFRSW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:22:56 -0400
Message-ID: <53A1D8FE.6030404@codeaurora.org>
Date: Wed, 18 Jun 2014 11:22:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Nico Pitre <nico@fluxnic.net>, LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Olof Johansson <olof@lixom.net>,
        Linaro Networking <linaro-networking@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8 kernels
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org> <CAGa+x85P-M3qUD6L=kezkiQ1NJymEZ9P=u2ANUZJu2b3F+o5LA@mail.gmail.com> <53A1D701.8060404@codeaurora.org> <CAGa+x86DfDjQG8gN2-x7Kapt2ipsYt879R4OK6JWGoaT93VVig@mail.gmail.com>
In-Reply-To: <CAGa+x86DfDjQG8gN2-x7Kapt2ipsYt879R4OK6JWGoaT93VVig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/14 11:21, Kevin Hilman wrote:
> On Wed, Jun 18, 2014 at 11:14 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 06/18/14 10:55, Kevin Hilman wrote:
>>> All of that to say, with this patch applied, I need a new (and
>>> reliable) way to determine the endianness of a kernel just by looking
>>> at the zImage.  Recommendations welcome.
>> Assuming that you have the .config configured to be built into the
>> kernel you could use extract-ikconfig
>>
>> $ ./scripts/extract-ikconfig zImage | grep CONFIG_CPU_ENDIAN_BE8
> Unfortunately, I can't rely on having that built in since I want the
> boot tools to be as generic as possible.
>
>

Yeah ok. Perhaps you can look for the 'setend be' instruction right
after the magic values instead.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

