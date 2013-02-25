Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3BYRAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:00:17 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:9657 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3BYRAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:00:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,735,1355097600"; 
   d="scan'208";a="1851999"
Message-ID: <512B98C9.2020008@citrix.com>
Date: Mon, 25 Feb 2013 18:00:57 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: switch from llist to list
References: <1360951381-26313-1-git-send-email-roger.pau@citrix.com> <20130215185644.GB29539@phenom.dumpdata.com> <511E88B4.7060205@citrix.com> <20130225164929.GB10672@phenom.dumpdata.com>
In-Reply-To: <20130225164929.GB10672@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/02/13 17:49, Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 15, 2013 at 08:12:52PM +0100, Roger Pau Monné wrote:
>> On 15/02/13 19:56, Konrad Rzeszutek Wilk wrote:
>>>> Should be backported to 3.8 stable.
>>>
>>> Lets do one thing at a time.
>>>
>>> The patch I have in the tree (and that I've asked Jens to pull for 3.9 - so
>>> he might have already in his tree) is the old hybrid where we still use llist
>>> but change the loop from 'for' to 'while'.
>>>
>>> This is the stable/for-jens-3.8 tree in git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git 
>>>
>>> Could you rebase your patch on top of that tree and just simplify the loop?
>>>
>>> Sorry about the mess about this - but I had already pulled the trigger
>>> so to say - hoping that Jens would pull the tree and do a git pull to Linus.
>>>
>>> And you are absolutly sure that we don't need any extra locking when switching
>>> over to list_head? Say if blkif_completion is called while we are
>>> processing in blkif_queue_request and doing ?
>>
>> Will recheck it, but blkif_completition is called with the io_lock hold,
>> as does blkif_queue_request (I've added extra assert_spin_locked before
>> every list modification).
> 
> Can you rebase this patch on top of 'stable/for-jens-3.9' when you get a chance
> please?

Yes, I was going to resubmit it as part of my indirect descriptors
series (which I'm hoping to send before the end of the week), but if you
are in a rush I can send it earlier, I already have it rebased on top of
for-jens-3.9.

