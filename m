Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3JBQK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:10:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38248 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3JBQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:10:25 -0400
Message-ID: <524C456F.4090704@wwwdotorg.org>
Date: Wed, 02 Oct 2013 10:10:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for
 BIAS_DEFAULT
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com> <524454F3.8000402@wwwdotorg.org> <52458876.4070205@nvidia.com> <5245AD0C.7070206@wwwdotorg.org> <CACRpkdbuetPbxPzJTpKuM4O-mqpqjh7rgGoanfAwad4M2vbZTQ@mail.gmail.com>
In-Reply-To: <CACRpkdbuetPbxPzJTpKuM4O-mqpqjh7rgGoanfAwad4M2vbZTQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 04:40 AM, Linus Walleij wrote:
> On Fri, Sep 27, 2013 at 6:06 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> [Laxman]
>>> Hmm.. When I added the PIN_DEFAULT, I just though that do not update
>>> anything in the register and implemented like that.
>>> There is nothing "default" option in HW.
>>
>> The description of that pinconfig option is:
>>
>>> 7970cb77 (Heiko Stübner    2013-06-06 16:44:25 +0200  43)  * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
>>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  44)  *    on embedded knowledge of the controller hardware, like current mux
>>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  45)  *    function. The pull direction and possibly strength too will normally
>>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  46)  *    be decided completely inside the hardware block and not be readable
>>> 70637a6d (Heiko Stübner    2013-06-25 14:55:42 +0200  47)  *    from the kernel side.
>>> 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  48)  *    If the argument is != 0 pull up/down is enabled, if it is 0, the
>>> 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  49)  *    configuration is ignored. The proper way to disable it is to use
>>> 5ca3353b (Linus Walleij    2013-06-16 12:43:06 +0200  50)  *    @PIN_CONFIG_BIAS_DISABLE.
>>
>> If the HW doesn't support any concept of a default pull, I think the
>> driver shouldn't support that option; it should return an error if asked
>> to program it.
> 
> Yes that's how I remember it and how we specified it.
> Correct Heiko?
> 
>> Presumably given this, LinusW shouldn't have actually applied this
>> patch, since presumably it prevents any other driver from accepting
>> PIN_CONFIG_BIAS_DISABLE even in cases where it is appropriate?
> 
> There are many patches I shouldn't have applied ...
> 
> Anyway I'm not quite following, this patch affected the Palmas
> driver only I think so how can it prevent any other drivers from doing
> the right thing?

Sorry, for some reason I thought this patch was touching core code
rather than the specific driver:-(

