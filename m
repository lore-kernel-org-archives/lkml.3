Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab3HXXhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 19:37:12 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:46771 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3HXXhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 19:37:10 -0400
Message-ID: <1377387845.32763.149.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v2 06/12] target: Add memory allocation for
 bidirectional commands
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <JBottomley@Parallels.com>
Date: Sat, 24 Aug 2013 16:44:05 -0700
In-Reply-To: <20130824151817.GA15588@infradead.org>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
	 <1377147250-10125-7-git-send-email-nab@daterainc.com>
	 <20130824151817.GA15588@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-24 at 08:18 -0700, Christoph Hellwig wrote:
> >  static int
> > +transport_generic_get_mem_bidi(struct se_cmd *cmd)
> 
> Except for the fields touched in struct se_cmd this is a duplication
> of transport_generic_get_mem.  I'd suggest to factor that one into
> a new helper:
> 
> static int
> target_alloc_sgl(struct scatterlist **sgl, unsigned int **nents,
> 		u32 length, gfp_t gfp_mask)
> {
> 	..
> }
> 
> and then call that one from transport_generic_new_cmd directly,

Sounds reasonable enough, doing that bit of refactoring now..

> including opencoding the actual BIDI case there as a first step.
> 

Not sure why this needs to be opencoded for BIDI, instead of just doing
target_alloc_sgl(&cmd->t_bidi_data_sg, ...) for the two SCF_BIDI ||
SCF_COMPARE_AND_WRITE cases in transport_generic_new_cmd()..?

--nab

