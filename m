Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaBUCHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:07:34 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51074 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752394AbaBUCHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:07:32 -0500
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Feb 2014 21:07:32 EST
Message-ID: <5306B4DF.4000901@hurleysoftware.com>
Date: Thu, 20 Feb 2014 21:07:27 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
References: <1392929071-16555-1-git-send-email-tj@kernel.org> <1392929071-16555-5-git-send-email-tj@kernel.org> <5306AF8E.3080006@hurleysoftware.com> <20140221015935.GF6897@htj.dyndns.org>
In-Reply-To: <20140221015935.GF6897@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 08:59 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Feb 20, 2014 at 08:44:46PM -0500, Peter Hurley wrote:
>>> +static void fw_device_workfn(struct work_struct *work)
>>> +{
>>> +	struct fw_device *device = container_of(to_delayed_work(work),
>>> +						struct fw_device, work);
>>
>> I think this needs an smp_rmb() here.
>
> The patch is equivalent transformation and the whole thing is
> guaranteed to have gone through pool->lock.  No explicit rmb
> necessary.

The spin_unlock_irq(&pool->lock) only guarantees completion of
memory operations _before_ the unlock; memory operations which occur
_after_ the unlock may be speculated before the unlock.

IOW, unlock is not a memory barrier for operations that occur after.

>> IOW, the beginning of the work function should act like a barrier in
>> the same way that queue_work_on() (et. al.) already does.
>
> workqueue already has enough barriers; otherwise, the whole kernel
> would have crumbled long time ago.

See above.

Regards,
Peter Hurley
