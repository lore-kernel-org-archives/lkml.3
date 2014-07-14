Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaGNIa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:30:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaGNIav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:30:51 -0400
Date: Mon, 14 Jul 2014 01:30:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to
 reflect the values on the host
Message-ID: <20140714083047.GB22715@infradead.org>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <1405183712-23967-1-git-send-email-kys@microsoft.com>
 <53C37575.5030808@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C37575.5030808@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 08:15:17AM +0200, Hannes Reinecke wrote:
> Limiting max_lun to 255 will make the driver to _not_ respond to LUNs higher
> than that; ie Well-known LUN won't work here.
> Also the SCSI stack will be using REPORT LUNS anyway since you're
> advertising SPC-2 compliance. So your driver runs into issues if Hyper-V
> would ever return more than 256 LUNs with the REPORT LUN command or if any
> of the LUNs has an addressing scheme other than
> '0x00'.
> I would suggest to raise this to the technical limit (ie the largest LUN
> which the _protocol_ supports) and let REPORT LUNS deal with the actual
> LUNs.

I suspect hypverv doesn't support anything more.  For now I'd be
inclined to just put it in ASAP and if your suggestion works out fix it
up later, although I'll wait a bit for more review feedback.

