Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbaAJTvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:51:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaAJTvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:51:06 -0500
Message-ID: <52D04F1A.2000808@redhat.com>
Date: Fri, 10 Jan 2014 11:50:50 -0800
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Sagi Grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>  <1389212157-14540-8-git-send-email-nab@daterainc.com>  <52CE78EB.60108@mellanox.com> <1389334891.5567.373.camel@haakon3.risingtidesystems.com>
In-Reply-To: <1389334891.5567.373.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 10:21 PM, Nicholas A. Bellinger wrote:
>> What about FORMAT_UNIT emulation?
>
> Would certainly be useful to have..
>
>> The backstore protection configuration is done at the target side via
>> configfs/targetcli, if you publish DIF support in
>> INQUERY_EVPD/READ_CAPACITY you need to accept protection information format?
>
> Mmmm, these two bits bits are following what scsi_debug is currently
> exposing minus FORMAT_UNIT support..?
>
> MKP..?

Yes, don't you need FORMAT UNIT because protection information is going 
to mean the pi-enabled lun will need to report less blocks? The ramdisk 
backstore changes in this series allocate extra space for PI info, but 
my understanding was that especially for emulation with block and fileio 
backstores, everything needs to go in the same amount of space.

Furthermore, if we want PI info stored along with the blocks, then block 
and fileio backstore formats are no longer going to be 1:1 -- requiring 
offset calculations, non-aligned read-modify-write, and all that 
unpleasantness to be handled?

I've looked at the patchset and the code looks good to me, so I guess 
I'm trying to understand the scope of future work needed on the 
backstore side for this support to be functional.

Regards -- Andy

