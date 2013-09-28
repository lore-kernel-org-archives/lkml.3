Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3I1WXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 18:23:24 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755084Ab3I1WXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 18:23:22 -0400
Message-ID: <524756D7.2020301@nod.at>
Date: Sun, 29 Sep 2013 00:23:19 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Elad Wexler <elad.wexler@gmail.com>
CC: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: cs5535-mfgpt: Replace 'module_init' with 'module_platform_driver'
References: <1380392082-23572-1-git-send-email-elad.wexler@gmail.com> <CAFLxGvzWsr7RCtxOcZ2LO1dSmjt0Khr91JAcM_NykCYRtd2R8Q@mail.gmail.com> <20130928221400.GA4630@gmail.com>
In-Reply-To: <20130928221400.GA4630@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.09.2013 00:14, schrieb Elad Wexler:
> On Sat, Sep 28, 2013 at 08:54:55PM +0200, richard -rw- weinberger wrote:
>> On Sat, Sep 28, 2013 at 8:14 PM,  <elad.wexler@gmail.com> wrote:
>>> From: Elad Wexler <elad.wexler@gmail.com>
>>>
>>> Driver doesn't do anything special in 'module_init'.
>>>
>>> 'module_platform_init' makes the code more readable.
>>>
>>> Signed-off-by: Elad Wexler <elad.wexler@gmail.com>
>>
>> NAK.
>>
>> By moving to module_platform_init() you make this module unloadable.
>> Currently it is unloadable for good reasons.
>> The cs5535-mfgpt chip is nasty because it has no reliable reset function.
>> Therefore by unloading and loading the module again bad things can happen.
>>
> I think this HW information should be well documented.
> Explaining the reason why it doesn't implemented the 'module_exit'

Usually if a driver does not implement the exit function it's because of hardware
limitations.
IOW, the alarm bell rings. ;-)

Thanks,
//richard
