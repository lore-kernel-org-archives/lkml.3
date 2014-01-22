Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaAVKHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:07:34 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35916 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaAVKHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:07:31 -0500
Message-ID: <52DF985A.60301@dev.mellanox.co.il>
Date: Wed, 22 Jan 2014 12:07:22 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH-v2 10/17] target: Add protection SGLs to target_submit_cmd_map_sgls
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>	 <1390099480-29013-11-git-send-email-nab@daterainc.com>	 <52DBC145.7040104@dev.mellanox.co.il> <1390342665.5567.776.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1390342665.5567.776.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2014 12:17 AM, Nicholas A. Bellinger wrote:
> On Sun, 2014-01-19 at 14:12 +0200, Sagi Grimberg wrote:
>> On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>>
>>> This patch adds support to target_submit_cmd_map_sgls() for
>>> accepting 'sgl_prot' + 'sgl_prot_count' parameters for
>>> DIF protection information.
>>>
>>> Note the passed parameters are stored at se_cmd->t_prot_sg
>>> and se_cmd->t_prot_nents respectively.
>>>
>>> Also, update tcm_loop and vhost-scsi fabrics usage of
>>> target_submit_cmd_map_sgls() to take into account the
>>> new parameters.
>> I didn't see that you added protection allocation to transports that
>> does not use
>> target_submit_cmd_map_sgls() - which happens to be iSCSI/iSER/SRP :(
>>
>> Don't you think that prot SG allocation should be added also to
>> target_alloc_sgl()? by then
>> se_cmd should contain the protection attributes and this routine can
>> know if it needs to
>> allocate prot_sg as well. This is how I used it...
> Yes, this specific bit was left out for the moment as no code in the
> patch for v3.14 actually uses it..
>
> I'm planning to add it to for-next -> v3.15 code as soon as the merge
> window closes.
>
> --nab
>

Yes, that makes sense to me.

Sagi.
