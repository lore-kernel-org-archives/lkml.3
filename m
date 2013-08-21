Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3HUGhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:37:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab3HUGhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:37:04 -0400
Date: Tue, 20 Aug 2013 23:37:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE
 data_direction
Message-ID: <20130821063702.GI25506@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
 <1377029280-19144-10-git-send-email-nab@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377029280-19144-10-git-send-email-nab@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:08:00PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@daterainc.com>
> 
> Add a special case for COMPARE_AND_WRITE for the reverse data direction
> mapping used for pci_map_sg() + friends.

A low level driver is an even worse place to hardcode a specific cdb
opcode.  As written before this should be done by a flag on the command.

Also it might make sense to lift this helper to get a dma direction from
a command into common code.

