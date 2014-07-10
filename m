Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaGJKZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:25:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaGJKY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:24:58 -0400
Date: Thu, 10 Jul 2014 03:24:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 2/8] Drivers: scsi: storvsc: Set cmd_per_lun to
 reflect value supported by the Host
Message-ID: <20140710102457.GA31692@infradead.org>
References: <1404974008-4984-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404974032-5023-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	.cmd_per_lun =		1,
> +	.cmd_per_lun =		255,
>  	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,

slave_configure immediately adjusts this down to STORVSC_MAX_IO_REQUESTS
(250), any reson to start out with the magic 255 here?

