Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaAVWYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:24:53 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:35335 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaAVWYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:24:51 -0500
Message-ID: <1390429620.5567.982.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v2 03/17] target/sbc: Add DIF setup in sbc_check_prot +
 sbc_parse_cdb
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@kernel.org>
Date: Wed, 22 Jan 2014 14:27:00 -0800
In-Reply-To: <52E00751.5010309@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
	 <1390099480-29013-4-git-send-email-nab@daterainc.com>
	 <52DBBA69.4040800@dev.mellanox.co.il>
	 <1390344494.5567.792.camel@haakon3.risingtidesystems.com>
	 <52E00751.5010309@dev.mellanox.co.il>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 20:00 +0200, Sagi Grimberg wrote:
> On 1/22/2014 12:48 AM, Nicholas A. Bellinger wrote:
> > +	cmd->prot_handover = PROT_SEPERATED;
> >> I know that we are not planning to support interleaved mode at the
> >> moment, But I think
> >> that the protection handover type is the backstore preference and should
> >> be taken from se_dev.
> >> But it is not that important for now...
> >>
> > Yeah, I figured since the RDMA pieces needed the handover type defined
> > in some form, it made sense to include PROT_SEPERATED hardcoded here,
> > but stopped short of adding se_dev->prot_handler for the first round
> > merge.
> >
> > --nab
> >
> 
> Actually they don't, I just added them in iSER code to demonstrate the 
> HW ability.
> If we are not planning to support that (although as MKP mentioned it 
> might be useful in some cases),
> you can remove that for now and we can add it in the future - iSER can 
> ignore it for now (I'll refactor the patches).
> 

<nod>

I'll likely leave this in for the initial merge to avoid rebasing
target-pending/for-next now that the merge window is open.

Let's drop this bit in a separate incremental patch.

--nab

