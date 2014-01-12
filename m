Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaALMxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:53:05 -0500
Received: from mail-ea0-f194.google.com ([209.85.215.194]:54294 "EHLO
	mail-ea0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaALMxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:53:02 -0500
Message-ID: <52D29026.6000302@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 14:52:54 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-10-git-send-email-nab@daterainc.com>	<yq161prr1p8.fsf@sermon.lab.mkp.net>	<52D28807.2000004@dev.mellanox.co.il> <yq138ktpdz9.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq138ktpdz9.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/2014 2:43 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
>>> The IP checksum is only supported by DIX between OS and initiator,
>>> not by the target. I guess we could signal to the initiator via a
>>> vendor-private VPD that IP checksum is supported directly. But now
>>> what we have hardware-accelerated T10 CRC I don't think it's a big
>>> deal.
> Sagi> shouldn't it stick around if it is not deprecated yet, the
> Sagi> transport is required to support ip-csum->CRC conversion anyhow.
>
> SBC mandates that the guard tag on the wire and on the target device be
> the T10 CRC. The IP checksum is a DIX-optimization for application-HBA
> exchanges. The only place you should support the IP checksum is in the
> initiator.

Right.

> Note that you could conceivably do a T10 CRC to IP checksum conversion
> on writes received by the target and store the IP checksum on disk. And
> then convert back to T10 CRC when the data is eventually read. But it
> makes no sense to do that given that you will have to do the T10 CRC
> calculation regardless. Even if the backing store is DIX-capable and
> supports the IP checksum.
>

I agree, but for backstore DIF (SW) emulation it will make sense.
