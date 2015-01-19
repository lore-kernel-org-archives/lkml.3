Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbbASPkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:40:11 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56808 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbASPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:40:08 -0500
Date: Tue, 20 Jan 2015 00:40:42 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fixup oops in ata_eh_link_report()
Message-ID: <20150119154042.GA971@swordfish>
References: <1421668859-4593-1-git-send-email-hare@suse.de>
 <20150119143738.GA979@swordfish>
 <54BD1A58.3000708@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BD1A58.3000708@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/19/15 15:53), Hannes Reinecke wrote:
> >> We should only try to evaluate the cdb if this is an ATAPI
> >> device, for any other device the 'cdb' field and the cdb_len
> >> has no meaning.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  drivers/ata/libata-eh.c | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> >> index 9179f11..584c6ae 100644
> >> --- a/drivers/ata/libata-eh.c
> >> +++ b/drivers/ata/libata-eh.c
> >> @@ -2481,8 +2481,6 @@ static void ata_eh_link_report(struct ata_link *link)
> >>  	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
> >>  		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
> >>  		struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
> >> -		const u8 *cdb = qc->cdb;
> >> -		size_t cdb_len = qc->dev->cdb_len;
> >>  		char data_buf[20] = "";
> >>  		char cdb_buf[70] = "";
> >>  
> >> @@ -2510,6 +2508,9 @@ static void ata_eh_link_report(struct ata_link *link)
> >>  		}
> >>  
> >>  		if (ata_is_atapi(qc->tf.protocol)) {
> >> +			const u8 *cdb = qc->cdb;
> >> +			size_t cdb_len = qd->dev->cdb_len;
> > 
> > I think, it supposed to be qc, not qd.
> > 
> Bzzt.
> 
> Of course.
> 
> I'll be redoing the patch, and will be adding the original commit id
> as indicated by Tejun.

Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG Nürnberg)
> 
