Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaFBS5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:57:25 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:37341 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaFBS5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:57:23 -0400
MIME-Version: 1.0
X-Originating-IP: [84.49.235.91]
In-Reply-To: <20140521.154744.124910385161203311.davem@davemloft.net>
References: <20140515.153721.2222505094570361361.davem@davemloft.net>
 <1400188890-2038-1-git-send-email-teg@jklm.no> <20140521.154744.124910385161203311.davem@davemloft.net>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 2 Jun 2014 20:57:02 +0200
Message-ID: <CAG-2HqUEqz26YMTDHNVHUEtWDcaVrq3EKX-e8-9wnm4Y1XCUag@mail.gmail.com>
Subject: Re: [PATCH v2] net: tunnels - enable module autoloading
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>, yoshfuji@linux-ipv6.org,
        jmorris@namei.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 9:47 PM, David Miller <davem@davemloft.net> wrote:
> From: Tom Gundersen <teg@jklm.no>
> Date: Thu, 15 May 2014 23:21:30 +0200
>
>> Enable the module alias hookup to allow tunnel modules to be autoloaded on demand.
>>
>> This is in line with how most other netdev kinds work, and will allow userspace
>> to create tunnels without having CAP_SYS_MODULE.
>>
>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>> ---
>> v2: add ';'
>>
>> Hi Dave,
>>
>> I must have sent out the wrong version of this patch. Sorry for the inconvenience!
>
> Applied to net-next

Thanks!

> although I never saw a firm conclusion in the
> thread for the original patch where there was a discussion about
> whether this is already possible or not.

It is my understanding that this is not already possible, which is why
the MODULE_ALIAS_RTNL_LINK exists.

Would this patch be suitable for stable? While it does not fix a
regression, it appears to fix the intended behaviour of
MODULE_ALIAS_RTNL_LINK?

What I'll do in userspace is to drop CAP_SYS_MODULE and just tell
people who want tunnels to wait for a new kernel (or backport the
patch), but having it in stable would obviously make it simpler.

Cheers,

Tom
