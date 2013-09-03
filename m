Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab3ICR3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:29:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46768 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3ICR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:29:06 -0400
Message-ID: <52261C5C.9000102@wwwdotorg.org>
Date: Tue, 03 Sep 2013 11:29:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars Poeschel <poeschel@lemonage.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdaWPQTPw8u+97iV8MRB1fdeS40kd242pJd3UE9Ler4kRQ@mail.gmail.com> <5220F849.8030909@wwwdotorg.org> <4094364.ACYUvMRRNa@lem-wkst-02>
In-Reply-To: <4094364.ACYUvMRRNa@lem-wkst-02>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2013 03:38 AM, Lars Poeschel wrote:
> Am Freitag, 30. August 2013, 13:53:45 schrieb Stephen Warren:
...
>> Yet the current patch only addresses a limited set of cases, since it
>> doesn't hook the APIs but rather parses the DT. It doesn't cover the
>> non-DT case. It should if the feature is useful.
> 
> As pointed out before, only DT has this problem, that,

That's completely false. Both DT and non-DT can represent the exact same
HW, and use the exact same drivers. It's equally possible to write a bug
in a board file or a DT file (i.e. a typo or incorrect reading of the
schematic) that causes the wrong GPIO or IRQ ID to be used, and hence
for there to be conflicts. Any solution to this issue needs to address
both cases.
