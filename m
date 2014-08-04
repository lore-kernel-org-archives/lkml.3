Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbaHDEBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:01:05 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60713 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaHDEBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:01:03 -0400
Subject: Re: [PATCH v1.3 4/18] arcmsr: limit max. number of SCSI command
 request
From: Ching Huang <ching2048@areca.com.tw>
To: Christoph Hellwig <hch@infradead.org>
Cc: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140801123552.GB30397@infradead.org>
References: <1406882389.10378.46.camel@Centos6.3-64>
	 <20140801123552.GB30397@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Aug 2014 12:00:55 +0800
Message-ID: <1407124855.5217.23.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 05:35 -0700, Christoph Hellwig wrote:
> > @@ -2220,8 +2220,7 @@ static int arcmsr_queue_command_lck(stru
> >  		arcmsr_handle_virtual_command(acb, cmd);
> >  		return 0;
> >  	}
> > -	if (atomic_read(&acb->ccboutstandingcount) >=
> > -			ARCMSR_MAX_OUTSTANDING_CMD)
> > +	if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding)
> >  		return SCSI_MLQUEUE_HOST_BUSY;
> 
> The scsi midlayer already takes care of this check for you.
> 

Hello Christoph,

We have 4 types of Adapter that some adpaters have command queue less
than ARCMSR_MAX_OUTSTANDING_CMD.
So we have to check outstanding command number here.

Thanks for your comment.
Ching

