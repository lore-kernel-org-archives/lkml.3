Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaGWMyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:54:53 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33304 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGWMyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:54:51 -0400
Date: Wed, 23 Jul 2014 13:54:43 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Message-ID: <20140723125443.GA16103@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org>
 <20140723115128.GB16881@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723115128.GB16881@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 04:51:28AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 23, 2014 at 11:04:48AM +0100, Sitsofe Wheeler wrote:
> > OK I've just seen this as I was about to post a similar patch to get
> > discard going on Hyper-V. Will your patches handle Hyper-V pass through devices
> > that support discard? The SSD I have here reports the following in the Linux
> > VM:
> 
> I didn't know hyperv also supports pass through, but it should work fine.
> The only thing I'm worried about is real SCSI-2 devices or crappy USB
> devices that don't support EVPD pages and might cause problems.  But
> let's ignore that problem for now..

That's good to know (I was worried the device would not be detected as
supporting discard because it doesn't report lbpme and doesn't declare a
conformance version (see below)). Is there a tree with all these updates
in or do they need to be pieced together from this email thread?

Additionally is it worth quirking sd_try_rc16_first on when
BLIST_TRY_VPD_PAGES is present?

# sg_inq  /dev/sdc
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x00  [no conformance claimed]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=60 (0x3c)   Peripheral device type: disk
 Vendor identification: ADATA   
 Product identification: SSD S510 120GB
 Product revision level: 5.2.
 Unit serial number: 03205115500300002076

-- 
Sitsofe | http://sucs.org/~sits/
