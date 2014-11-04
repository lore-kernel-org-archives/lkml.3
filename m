Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaKDNf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:35:56 -0500
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:39565 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaKDNfx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:35:53 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <5458D636.3000401@topic.nl>
Date: Tue, 4 Nov 2014 14:35:50 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <20141030165133.GB18557@sirena.org.uk> <54573860.4060708@topic.nl> <20141103120919.GE3815@sirena.org.uk> <545795D8.1040600@topic.nl> <20141103151058.GP3815@sirena.org.uk> <5457BD85.2070901@topic.nl> <54589472.8030305@topic.nl> <20141104113417.GG3815@sirena.org.uk>
In-Reply-To: <20141104113417.GG3815@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 11/04/2014 12:34 PM, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 09:55:14AM +0100, Mike Looijmans wrote:
>> ﻿On 11/03/2014 06:38 PM, Mike Looijmans wrote:
>
>>>> You need to develop against current versions of the kernel, this is
>>>> something that was merged into Linus' tree during the merge window.
>
>>> Is this an absolute show-stopper for you?
>
>>> With some effort I could move from our current 3.15 to 3.17, but even that
>>> wouldn't be recent enough then. I can justify spending a few days on getting
>>> the driver integrated into mainline, even if the initial version cost less
>>> than that; but moving everything to mainline is going to take weeks and the
>>> boss is definitely going to say "no" to that.
>
> It should be easy to backport the support into your current kernel, it's
> just a few commits and there hasn't been much development in this area
> of the code.  Can you take a look at doing that please?

I can cherry-pick about 4 commits to get the updated core into my 3.15 tree.

I still need help with one thing that isn't clear to me though. The DT is 
parsed when calling regulator_register. But then how do I fetch my "private" 
settings in there BEFORE the regulator gets enabled? The feedback resistors 
and regulator mode must be set to the correct board before the output is 
enabled, otherwise it may damage the chip and its periferals.

The only two drivers using the regulators_node (tps65217 and isl9305.c) don't 
have any private values in the DT.

M.


Met vriendelijke groet / kind regards,

Mike Looijmans
System Expert


TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

