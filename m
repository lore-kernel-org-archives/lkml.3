Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaJTGyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:54:00 -0400
Received: from verein.lst.de ([213.95.11.211]:47104 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaJTGx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:53:59 -0400
Date: Mon, 20 Oct 2014 08:53:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>,
        Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] scsi_dh: get module reference outside of device
	handler
Message-ID: <20141020065355.GA6675@lst.de>
References: <1413734404-1426-1-git-send-email-hch@lst.de> <1413734404-1426-2-git-send-email-hch@lst.de> <5444A530.3080204@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5444A530.3080204@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 08:01:20AM +0200, Hannes Reinecke wrote:
> Is it guaranteed that you cannot call ->attach() for devices which
> already have a device_handler attached?
> You've skipped the case
> 
> scsi_dh != sdev->scsi_dh_data->scsi_dh

No.  Just instead of an if / else it's an if with an early return in the
new code.

