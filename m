Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3F1KUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:20:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1830 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab3F1KUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:20:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,958,1363132800"; 
   d="scan'208";a="32420673"
Message-ID: <51CD6358.5080603@citrix.com>
Date: Fri, 28 Jun 2013 11:20:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] time: indicate that the clock was set in the pvclock
 gtod notifier chain
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-4-git-send-email-david.vrabel@citrix.com> <51CC7850.2040602@linaro.org>
In-Reply-To: <51CC7850.2040602@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/13 18:37, John Stultz wrote:
> On 06/27/2013 03:35 AM, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> If the clock was set (stepped), set the action parameter to functions
>> in the pvclock gtod notifier chain to non-zero.  This allows the
>> callee to only do work if the clock was stepped.
>>
>> This will be used on Xen as the synchronization of the Xen wallclock
>> to the control domain's (dom0) system time will be done with this
>> notifier and updating on every timer tick is unnecessary and too
>> expensive.
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> 
> Looks pretty good. Minor note below.

I've fixed this and the other minor change you requested.

You can pull the wallclock-v7 branch from

   git://xenbits.xen.org/people/dvrabel/linux.git

or, if you prefer, I can repost the series.

David
