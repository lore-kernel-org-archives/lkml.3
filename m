Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbaAJUN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:13:26 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:49443 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaAJUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:13:24 -0500
Message-ID: <1389384908.5567.428.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 07/14] target/sbc: Add P_TYPE + PROT_EN bits to
 READ_CAPACITY_16
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Andy Grover <agrover@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Date: Fri, 10 Jan 2014 12:15:08 -0800
In-Reply-To: <52D04F1A.2000808@redhat.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-8-git-send-email-nab@daterainc.com>
	 <52CE78EB.60108@mellanox.com>
	 <1389334891.5567.373.camel@haakon3.risingtidesystems.com>
	 <52D04F1A.2000808@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 11:50 -0800, Andy Grover wrote:
> On 01/09/2014 10:21 PM, Nicholas A. Bellinger wrote:
> >> What about FORMAT_UNIT emulation?
> >
> > Would certainly be useful to have..
> >
> >> The backstore protection configuration is done at the target side via
> >> configfs/targetcli, if you publish DIF support in
> >> INQUERY_EVPD/READ_CAPACITY you need to accept protection information format?
> >
> > Mmmm, these two bits bits are following what scsi_debug is currently
> > exposing minus FORMAT_UNIT support..?
> >
> > MKP..?
> 
> Yes, don't you need FORMAT UNIT because protection information is going 
> to mean the pi-enabled lun will need to report less blocks?

FORMAT_UNIT is simply a mechanism that allows the client to setup the
protection information remotely, to complement the per device configfs
attribute that does the same thing from the target side.

> The ramdisk backstore changes in this series allocate extra space for
> PI info, but my understanding was that especially for emulation with
> block and fileio backstores, everything needs to go in the same amount
> of space.
> 

No, that's only for the interleaved case.

> Furthermore, if we want PI info stored along with the blocks, then block 
> and fileio backstore formats are no longer going to be 1:1 -- requiring 
> offset calculations, non-aligned read-modify-write, and all that 
> unpleasantness to be handled?
> 

I'm currently not intending to support interleaved mode into the
backend, given that backends not doing emulation expect these to be in
seperate SGLs to start.

--nab

