Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaJKRl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:41:58 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50720 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbaJKRl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:41:57 -0400
Message-ID: <1413049313.2068.48.camel@jarvis.lan>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Date: Sat, 11 Oct 2014 10:41:53 -0700
In-Reply-To: <20141011173902.GA1946@infradead.org>
References: <20141010074901.GA32028@sucs.org>
	 <20141011173902.GA1946@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 10:39 -0700, Christoph Hellwig wrote:
> On Fri, Oct 10, 2014 at 08:49:01AM +0100, Sitsofe Wheeler wrote:
> > Microsoft Hyper-V virtual disks currently only claim SPC-2 compliance
> > even though they implement post SPC-2 features (such as thin
> > provisioning) which means the Linux kernel does not go on to test for
> > those features even though they are advertised.
> > 
> > A previous patch attempted to add a quirk to workaround this but the
> > quirk was only enabled after the features had been scanned for, wouldn't
> > work for "small" disks and would quirk on  all Hyper-V SCSI devices
> > (e.g. passthrough disks).
> > 
> > The new patches partially revert the previous effort, add the quirk in a
> > more traditional manner to only Hyper-V virtual disks and work on small
> > virtual disks.
> 
> This seems like might want a quirk to simply "force" a SPC3 compliance
> level?

This was initially suggested, but rejected by Microsoft because of other
problems advertising SPC-3 compliance brings.  Perhaps the hyper-v
emulator has matured sufficiently that it will now work OK?

James


