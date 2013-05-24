Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3EXPpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:45:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59143 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3EXPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:45:10 -0400
Message-ID: <519F8B02.1080000@wwwdotorg.org>
Date: Fri, 24 May 2013 09:45:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: ext Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Subject: Re: [PATCH] pinctrl: sink pinctrldev_list_mutex
References: <1368690525-32252-1-git-send-email-linus.walleij@stericsson.com> <519A8A57.9060007@wwwdotorg.org> <CACRpkdZieCmFnHCGUkv8EqcAtb3DA7dSZpimSdB4P81tZPJRoQ@mail.gmail.com>
In-Reply-To: <CACRpkdZieCmFnHCGUkv8EqcAtb3DA7dSZpimSdB4P81tZPJRoQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 02:04 AM, Linus Walleij wrote:
> On Mon, May 20, 2013 at 10:40 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> This seems fine on the surface, but I do have one question:
>>
>> I think the pinctrl lock serves a couple of purposes:
>>
>> 1) Basic protection for accesses to the pinctrldev_list itself.
>>
>> This patch seems just fine w.r.t. this point.
>>
>> 2) Preventing pinctrl drivers from being unregistered (and their modules
>> unloaded) when some operation is being performed on/to them.
> 
> Prevention of module unloading of pin controllers has never
> been working properly, as there is no way to release the
> pinctrl handles taken by different drivers.
> 
> I think that is why most pin controller drivers are bool rather
> than tristate.

Once we get to multi-platform distro kernels, we will probably want all
the pinctrl drivers to be modules so only the correct one gets loaded
from an initrd. Hence, we'll want to move things to tristate rather than
away from it.

If we know the pinctrl subsystem doesn't yet work correctly with module
unloads, should we modify pinctrl_register() to simply take a lock on
the driver module and never drop it, so that we guarantee we don't try
to unload the module later? Or, is this effectively already in place?

In other words, I can accept that we know that we can't unload pinctrl
drivers, but given that, I think the kernel should make sure the user
/actually/ can't unload them.
