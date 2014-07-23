Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbaGWKE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:04:58 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63620 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140AbaGWKE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:04:56 -0400
Date: Wed, 23 Jul 2014 11:04:48 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com, apw@canonical.com,
        jasowang@redhat.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Message-ID: <20140723100448.GA2540@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405983961-18782-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 04:06:01PM -0700, K. Y. Srinivasan wrote:
> Add blist flags to permit the reading of the VPD pages even when
> the target may claim SPC-2 compliance. MSFT targets currently
> claim SPC-2 compliance while they implement post SPC-2 features.
> With this patch we can correctly handle WRITE_SAME_16 issues.

OK I've just seen this as I was about to post a similar patch to get
discard going on Hyper-V. Will your patches handle Hyper-V pass through devices
that support discard? The SSD I have here reports the following in the Linux
VM:

# sg_vpd -p lbpv  /dev/sdc
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 1
  Write same (16) with unmap bit supported (LBWS): 0
  Write same (10) with unmap bit supported (LBWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 1
  Threshold exponent: 0
  Descriptor present (DP): 0
  Provisioning type: 0

# sg_readcap -l /dev/sdc
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=234441647 (0xdf94baf), Number of logical blocks=234441648
   Logical block length=512 bytes
   Logical blocks per physical block exponent=0
   Lowest aligned logical block address=0
Hence:
   Device size: 120034123776 bytes, 114473.5 MiB, 120.03 GB

-- 
Sitsofe | http://sucs.org/~sits/
