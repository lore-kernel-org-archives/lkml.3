Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3HUGcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:32:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3HUGcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:32:24 -0400
Date: Tue, 20 Aug 2013 23:32:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/9] target: Skip ->queue_data_in() callbacks for
 COMPARE_AND_WRITE
Message-ID: <20130821063223.GG25506@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
 <1377029280-19144-6-git-send-email-nab@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377029280-19144-6-git-send-email-nab@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1832,7 +1832,8 @@ static void transport_complete_qf(struct se_cmd *cmd)
>  		ret = cmd->se_tfo->queue_data_in(cmd);
>  		break;
>  	case DMA_TO_DEVICE:
> -		if (cmd->t_bidi_data_sg) {
> +		if (cmd->t_bidi_data_sg &&
> +		    cmd->t_task_cdb[0] != COMPARE_AND_WRITE) {

This is not the place to hardcode specific cdb opcodes.  Should be
a flag with a defined meaning on the command.

