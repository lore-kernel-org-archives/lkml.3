Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3BKRjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:39:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58891 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab3BKRjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:39:21 -0500
Message-ID: <51192CC5.9060300@wwwdotorg.org>
Date: Mon, 11 Feb 2013 10:39:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-8-git-send-email-acourbot@nvidia.com> <CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com> <CAAVeFu+phNtzzj7rw96g9iH8sj9gGqd5SfAqtkDHvu3PeL_oQA@mail.gmail.com> <20130209091729.978C73E1A18@localhost> <CACRpkdagLssOG3FW8Qr1zqFabGMgdupADwg1=c0eQ7e76_XM5A@mail.gmail.com>
In-Reply-To: <CACRpkdagLssOG3FW8Qr1zqFabGMgdupADwg1=c0eQ7e76_XM5A@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 07:09 AM, Linus Walleij wrote:
> On Sat, Feb 9, 2013 at 10:17 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
>> The ERR_PTR()/IS_ERR() is a horrible pattern for code
>> readability because it breaks the expectations that programmers have for
>> what is and is not a bad pointer. There are decades of history where the
>> test for a bad pointer is 'if (!ptr)'. Not only does ERR_PTR make make
>> that test not work, but the compiler won't tell you when you get it
>> wrong.
>>
>> There are places where ERR_PTR makes sense. Particularly when
>> communicating with userspace where error codes have very specific
>> meanings, but I don't want it in the GPIO subsystem.
> 
> OK I disagree but you get to decide.
> 
> However if you take this all the way to the descriptor API
> it will make the consumer (driver) API for GPIO descriptors deviate
> from what is today used for clocks, regulators and pins.
> 
> With all the resulting confusion for users.
> I've seen worse subsystem deviations though.

Sorry I haven't looked at the specific APIs this discussion refers to,
but clients of the GPIO descriptor API are going to need to distinguish
"fail" from "deferred probe", so at least some initial get-like API will
need to pass back some error detail...
