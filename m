Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaJUERT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:17:19 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58333 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaJUERO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:17:14 -0400
Date: Tue, 21 Oct 2014 05:17:08 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Message-ID: <20141021041707.GA11691@sucs.org>
References: <20141010074901.GA32028@sucs.org>
 <yq1r3ya6t0i.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1r3ya6t0i.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 09:06:37PM -0400, Martin K. Petersen wrote:
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> A previous patch attempted to add a quirk to workaround this
> Sitsofe> but the quirk was only enabled after the features had been
> Sitsofe> scanned for, wouldn't work for "small" disks 
> 
> What does that mean, exactly?

It means:

1. The committed patches never worked because the running of the code to
test whether the quirk should be enabled happened after the probing code
the quirk would have affected ran. So roughly:

bflag = 0;
if (feature || bflag) {
	do_stuff();
}
if (matching_dev) {
	bflag = 1; // Too late...
}

See https://lkml.org/lkml/2014/7/23/615 for prior details.

2. On top of the above, when a disk is "small" (has less than 2^32
sectors which is typically < 2 TBytes in size) READ CAPACITY(16) won't
be triggered. If READ CAPACITY(16) isn't triggered then the lbpme bytes
won't be checked, thin provisioning will never be enabled and the
committed patch would doubly not work for such disks.

Apologies for the delay in replying.

-- 
Sitsofe | http://sucs.org/~sits/
