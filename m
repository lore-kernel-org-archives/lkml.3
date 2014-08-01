Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaHAMfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:35:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42553 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbaHAMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:35:54 -0400
Date: Fri, 1 Aug 2014 05:35:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1.3 4/18] arcmsr: limit max. number of SCSI command
 request
Message-ID: <20140801123552.GB30397@infradead.org>
References: <1406882389.10378.46.camel@Centos6.3-64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406882389.10378.46.camel@Centos6.3-64>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2220,8 +2220,7 @@ static int arcmsr_queue_command_lck(stru
>  		arcmsr_handle_virtual_command(acb, cmd);
>  		return 0;
>  	}
> -	if (atomic_read(&acb->ccboutstandingcount) >=
> -			ARCMSR_MAX_OUTSTANDING_CMD)
> +	if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding)
>  		return SCSI_MLQUEUE_HOST_BUSY;

The scsi midlayer already takes care of this check for you.

