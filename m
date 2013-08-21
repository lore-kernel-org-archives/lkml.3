Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3HURqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:46:02 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:55587 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab3HURp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:45:59 -0400
Message-ID: <1377107568.32763.59.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE
 data_direction
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@purestorage.com>,
        "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        James Bottomley <JBottomley@parallels.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>
Date: Wed, 21 Aug 2013 10:52:48 -0700
In-Reply-To: <20130821155314.GA17850@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <1377029280-19144-10-git-send-email-nab@daterainc.com>
	 <CAL1RGDVSrf6++PMdfnAZAUw=QX0VbQ9Wck+v=7ebfc-_FXJ_NA@mail.gmail.com>
	 <20130821155314.GA17850@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 08:53 -0700, Christoph Hellwig wrote:
> On Wed, Aug 21, 2013 at 07:38:21AM -0700, Roland Dreier wrote:
> > I don't understand this.  In fact the whole patch series looks quite
> > confused.  COMPARE AND WRITE is a normal Data-Out command, with no
> > requirement for special bidirectional handling or anything like that.
> > The only slightly unusual thing is that a CAW command with a NUMBER OF
> > LOGICAL BLOCKS equal to N will actually transfer 2*N worth of data --
> > one set of data for the compare operation and a second set to write if
> > the compare succeeds.  But just to be clear, the transfer of those 2*N
> > blocks happens as a single transfer during the Data-Out phase.
> 
> I think the confusion is that the implementation of COMPARE AND WRITE
> obviously requires a read and a write phase, and the implementation
> tries to mix this up with an actual bidirectional scsi command.
> 
> If the core stopped keying off t_bidi_data_sg and used better flag
> this could be easily solved.

Good point here as well..  Changing these cases to check for SCF_BIDI
instead, and adding a extra SCF_COMPARE_AND_WRITE check for the case in
transport_generic_new_cmd() to call transport_generic_get_mem_bidi().

--nab

