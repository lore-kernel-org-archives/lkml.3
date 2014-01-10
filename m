Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaAJGv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:51:56 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:45105 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaAJGvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:51:53 -0500
Message-ID: <1389336816.5567.404.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 02/14] target: Add DIF CHECK_CONDITION ASC/ASCQ
 exception cases
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Or Gerlitz <ogerlitz@mellanox.com>
Date: Thu, 09 Jan 2014 22:53:36 -0800
In-Reply-To: <52CE7D3F.7030308@mellanox.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-3-git-send-email-nab@daterainc.com>
	 <52CE7D3F.7030308@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 12:43 +0200, Sagi Grimberg wrote:
> On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds support for DIF related CHECK_CONDITION ASC/ASCQ
> > exception cases into transport_send_check_condition_and_sense().
> >
> > This includes:
> >
> >    LOGICAL BLOCK GUARD CHECK FAILED
> >    LOGICAL BLOCK APPLICATION TAG CHECK FAILED
> >    LOGICAL BLOCK REFERENCE TAG CHECK FAILED
> >
> > that used by DIF TYPE1 and TYPE3 failure cases.
> >
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Or Gerlitz <ogerlitz@mellanox.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
> >   include/target/target_core_base.h      |    3 +++
> >   2 files changed, 33 insertions(+)
> >
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 91953da..707ee17 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -2648,6 +2648,36 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
> >   		buffer[SPC_ASC_KEY_OFFSET] = 0x1d;
> >   		buffer[SPC_ASCQ_KEY_OFFSET] = 0x00;
> >   		break;
> > +	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
> > +		/* CURRENT ERROR */
> > +		buffer[0] = 0x70;
> > +		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
> > +		/* ILLEGAL REQUEST */
> > +		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
> > +		/* LOGICAL BLOCK GUARD CHECK FAILED */
> > +		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
> > +		buffer[SPC_ASCQ_KEY_OFFSET] = 0x01;
> 
> You have Enums for ASCQs (TARGET_GUARD_CHECK_FAILED, 
> TARGET_APPTAG_CHECK_FAILED, TARGET_REFTAG_CHECK_FAILED). either use them 
> or loose them.

<nod>, dropping these extra definitions.

--nab

