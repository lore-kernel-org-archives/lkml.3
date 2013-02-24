Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3BXSxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 13:53:16 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64044 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3BXSxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 13:53:14 -0500
Message-ID: <512A6197.2000908@lwfinger.net>
Date: Sun, 24 Feb 2013 12:53:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep splat when unloading b43
References: <512A4E83.5090901@lwfinger.net> <20130224193239.3517e6ac@milhouse>
In-Reply-To: <20130224193239.3517e6ac@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 12:32 PM, Michael Büsch wrote:
> On Sun, 24 Feb 2013 11:31:47 -0600
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> With the current wireless-testing tree, unloading b43 produces the lockdep log
>> splat copied below. My understanding of locking is deficient, and I would like
>> to learn. Any help on understanding this problem is appreciated.
>
> A few questions:
> Is there any reason for using the global workqueue and not mac80211's workqueue?

My original thought was that we needed the firmware load queue before mac80211 
was running for b43; however, I now realize that my thinking was wrong.

> Why is the workqueue cancelled in the core_stop callback? Wouldn't it make more
> sense to cancel it in bcma_remove/ssb_remove?

It certainly would.

> This would probably fix the circular dependency. But I'm not entirely sure, because
> I'm not that familiar with the code anymore.

I know that a lot has changed, but your instincts are still good.

Thanks,

Larry



