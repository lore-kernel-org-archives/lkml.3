Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaAJUqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:46:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30050 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbaAJUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:46:33 -0500
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-8-git-send-email-nab@daterainc.com>
	<52CE78EB.60108@mellanox.com>
	<1389334891.5567.373.camel@haakon3.risingtidesystems.com>
	<52D04F1A.2000808@redhat.com>
Date: Fri, 10 Jan 2014 15:46:17 -0500
In-Reply-To: <52D04F1A.2000808@redhat.com> (Andy Grover's message of "Fri, 10
	Jan 2014 11:50:50 -0800")
Message-ID: <yq1eh4fr2ee.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andy" == Andy Grover <agrover@redhat.com> writes:

Andy> Yes, don't you need FORMAT UNIT because protection information is
Andy> going to mean the pi-enabled lun will need to report less blocks?

Modern disk drives won't shrink when you reformat them with PI. This is
a result of an IDEMA agreement about LBA counts.

And if you create a 10GB PI LUN on an array you'll get 10GB for data.

Andy> The ramdisk backstore changes in this series allocate extra space
Andy> for PI info, but my understanding was that especially for
Andy> emulation with block and fileio backstores, everything needs to go
Andy> in the same amount of space.

For both file and block I'd recommend we store the PI in a separate
block device or file unless the backing device is PI-capable.

Andy> Furthermore, if we want PI info stored along with the blocks, then
Andy> block and fileio backstore formats are no longer going to be 1:1
Andy> -- requiring offset calculations, non-aligned read-modify-write,
Andy> and all that unpleasantness to be handled?

I only think interleaved makes sense if you're passing the PI through
instead of emulating.

-- 
Martin K. Petersen	Oracle Linux Engineering
