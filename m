Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaGJKSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:18:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaGJKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:18:50 -0400
Date: Thu, 10 Jul 2014 03:18:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 7/8] drivers: scsi: storvsc: Set srb_flags in all cases
Message-ID: <20140710101849.GD1151@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-7-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404866812-26950-7-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	default:
>  		vm_srb->data_in = UNKNOWN_TYPE;
> -		vm_srb->win8_extension.srb_flags = 0;
> +		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_DATA_IN |
> +						     SRB_FLAGS_DATA_OUT);

This would usually be a command that doesn't transfer data (e.g.
TEST_UNIT_READY or SYNCHRONIZE_CACHE), do you really want to set the in
and out flags here?

