Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaALLtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 06:49:43 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:55894 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaALLtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 06:49:41 -0500
Message-ID: <52D28150.8090908@dev.mellanox.co.il>
Date: Sun, 12 Jan 2014 13:49:36 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andy Grover <agrover@redhat.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	<1389212157-14540-8-git-send-email-nab@daterainc.com>	<52CE78EB.60108@mellanox.com>	<1389334891.5567.373.camel@haakon3.risingtidesystems.com>	<52D04F1A.2000808@redhat.com> <yq1eh4fr2ee.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1eh4fr2ee.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2014 10:46 PM, Martin K. Petersen wrote:
>>>>>> "Andy" == Andy Grover <agrover@redhat.com> writes:
> Andy> Yes, don't you need FORMAT UNIT because protection information is
> Andy> going to mean the pi-enabled lun will need to report less blocks?
>
> Modern disk drives won't shrink when you reformat them with PI. This is
> a result of an IDEMA agreement about LBA counts.
>
> And if you create a 10GB PI LUN on an array you'll get 10GB for data.
>
> Andy> The ramdisk backstore changes in this series allocate extra space
> Andy> for PI info, but my understanding was that especially for
> Andy> emulation with block and fileio backstores, everything needs to go
> Andy> in the same amount of space.
>
> For both file and block I'd recommend we store the PI in a separate
> block device or file unless the backing device is PI-capable.
>
> Andy> Furthermore, if we want PI info stored along with the blocks, then
> Andy> block and fileio backstore formats are no longer going to be 1:1
> Andy> -- requiring offset calculations, non-aligned read-modify-write,
> Andy> and all that unpleasantness to be handled?
>
> I only think interleaved makes sense if you're passing the PI through
> instead of emulating.
>

I agree, I implemented interleaved mode just as a proof of concept that 
our HW can perform offload in that manner.
I assume we can stick with non-interleaved, although it can be added as 
a user option.

Sagi.
