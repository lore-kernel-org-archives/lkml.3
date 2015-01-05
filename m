Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbbAETdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:33:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35926 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbbAETdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:33:08 -0500
Message-ID: <54AAE71F.2040809@wwwdotorg.org>
Date: Mon, 05 Jan 2015 12:33:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: balbi@ti.com, Thierry Reding <thierry.reding@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com> <20141223183633.GH9147@saruman>
In-Reply-To: <20141223183633.GH9147@saruman>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 11:36 AM, Felipe Balbi wrote:
> On Thu, Dec 04, 2014 at 01:06:07PM +0100, Thierry Reding wrote:
>> From: Thierry Reding <treding@nvidia.com>
>>
>> Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
>> failure") broke platforms that rely on deferred probing to order probing
>> of PHY and host controller drivers. The reason is that the commit simply
>> propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
>> PHY has been registered yet for a given device tree node. The only case
>> in which -EPROBE_DEFER would now be returned is if try_module_get() did
>> fail, which does not make sense.
>>
>> The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
>> registered yet. The only condition under which it makes sense to return
>> -ENODEV is if the device tree node representing the PHY has been
>> disabled (via the status property) because in that case the PHY will
>> never be registered.
>>
>> This patch addresses the problem by making __of_usb_find_phy() return an
>> appropriate error code while keeping in line with the above-mentioned
>> commit to propagate error codes rather than overwriting them. At the
>> same time the check for a valid PHY is decoupled from the check for the
>> try_module_get() call and a separate error code is returned if the
>> latter fails.
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>
> you forgot to add the magic "Fixes: foo bar" here, I'll add it this
> time, but I've already sent my -rc2 pull request, so this will only show
> up on -rc3.

Presumably also add the following, since the patch fixes a regression in 
a previous kernel release:

Cc: stable # v3.18

?

