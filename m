Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaHDLDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:03:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaHDLDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:03:12 -0400
Date: Mon, 4 Aug 2014 04:03:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Juergen Gross <jgross@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Save command pool address of Scsi_Host
Message-ID: <20140804110310.GA19109@infradead.org>
References: <1406874425-3528-1-git-send-email-jgross@suse.com>
 <20140801120301.GA27198@infradead.org>
 <1406924674.2654.19.camel@jarvis>
 <53DF0AA3.2040209@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DF0AA3.2040209@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 06:22:59AM +0200, Juergen Gross wrote:
> OTOH it would be possible to just delete .cmd_pool in the template when
> deleting the pool. I'll send a patch doing this and you can decide
> whether to take it or to use the other solution.
> 
> I'm not sure which to prefer: the init/remove version is simple, while
> the dynamic version requires no changes in the driver's source and the
> pool's resources are allocated only when really needed.

the init/remove version needs the driver to call a per-host template
function/method from module_init/exit, something we've avoided
successfully for the last 10 years.


