Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3HUOip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:38:45 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:47705 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751865Ab3HUOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <1377029280-19144-10-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com> <1377029280-19144-10-git-send-email-nab@daterainc.com>
From: Roland Dreier <roland@purestorage.com>
Date: Wed, 21 Aug 2013 07:38:21 -0700
Message-ID: <CAL1RGDVSrf6++PMdfnAZAUw=QX0VbQ9Wck+v=7ebfc-_FXJ_NA@mail.gmail.com>
Subject: Re: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE data_direction
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        James Bottomley <JBottomley@parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 1:08 PM, Nicholas A. Bellinger
<nab@daterainc.com> wrote:
> Add a special case for COMPARE_AND_WRITE for the reverse data direction
> mapping used for pci_map_sg() + friends.

I don't understand this.  In fact the whole patch series looks quite
confused.  COMPARE AND WRITE is a normal Data-Out command, with no
requirement for special bidirectional handling or anything like that.
The only slightly unusual thing is that a CAW command with a NUMBER OF
LOGICAL BLOCKS equal to N will actually transfer 2*N worth of data --
one set of data for the compare operation and a second set to write if
the compare succeeds.  But just to be clear, the transfer of those 2*N
blocks happens as a single transfer during the Data-Out phase.

 - R.
