Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbaGCSAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:00:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59733 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbaGCSAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:00:09 -0400
Message-ID: <1404410407.5091.9.camel@jarvis>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        SCSI Mailing List <linux-scsi@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 03 Jul 2014 11:00:07 -0700
In-Reply-To: <20140703163310.GA21213@infradead.org>
References: <20140628174605.352098823@linuxfoundation.org>
	 <20140628174609.930049472@linuxfoundation.org>
	 <1404339330.1862.69.camel@ul30vt.home> <53B48B37.4000608@cs.wisc.edu>
	 <1404341555.16066.19.camel@dabdike> <20140703060548.GB17456@infradead.org>
	 <1404395645.1949.2.camel@jarvis.lan> <20140703162748.GA24758@kroah.com>
	 <20140703163310.GA21213@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 09:33 -0700, Christoph Hellwig wrote:
> On Thu, Jul 03, 2014 at 09:27:48AM -0700, Greg Kroah-Hartman wrote:
> > I copy everyone on the patch.  You were not on that patch as it doesn't
> > look like it went through your tree at all.
> 
> It went through the target tree despite exclusive touching scsi
> initiator side code.  I'm still not sure how this happened, but we
> should take care to avoid this in the future.  In addition to this
> regression due to a complete lack of testing it also caused various
> merge issues.

OK, Nic cc'd

Please explain how this commit:

commit d77e65350f2d82dfa0557707d505711f5a43c8fd
Author: Sagi Grimberg <sagig@mellanox.com>
Date:   Wed Jun 11 12:09:58 2014 +0300

    libiscsi, iser: Adjust data_length to include protection information
    
    In case protection information exists over the wire
    iscsi header data length is required to include it.
    Use protection information aware scsi helpers to set
    the correct transfer length.
    
    In order to avoid breakage, remove iser transfer length
    checks for each task as they are not always true and
    somewhat redundant anyway.
    
    Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
    Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
    Acked-by: Mike Christie <michaelc@cs.wisc.edu>
    Cc: stable@vger.kernel.org # 3.15+
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

 drivers/infiniband/ulp/iser/iser_initiator.c | 34 ++++++++--------------------
 drivers/scsi/libiscsi.c                      | 18 +++++++--------

Came to go through the target tree even though it's initiator only and
how come it was tagged for stable?

James


