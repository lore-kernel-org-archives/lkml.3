Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208Ab3IDX1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761013Ab3IDX1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:27:34 -0400
Date: Wed, 4 Sep 2013 19:27:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, bgrove@attotech.com
Subject: Re: [SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID
 Adapter Driver
Message-ID: <20130904232725.GA5727@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org, bgrove@attotech.com
References: <20130903233716.5333B660D6B@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903233716.5333B660D6B@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +struct esas2r_adapter {
 > +	struct esas2r_target targetdb[ESAS2R_MAX_TARGETS];
 > +	struct esas2r_target *targetdb_end;
 ... 
 > +	u8 fw_coredump_buff[ESAS2R_FWCOREDUMP_SZ];


 > +void esas2r_reset_chip(struct esas2r_adapter *a)
 > +{
 > +	if (!esas2r_is_adapter_present(a))
 > +		return;
 > +
 > +	/*
 > +	 * Before we reset the chip, save off the VDA core dump.  The VDA core
 > +	 * dump is located in the upper 512KB of the onchip SRAM.  Make sure
 > +	 * to not overwrite a previous crash that was saved.
 > +	 */
 > +	if ((a->flags2 & AF2_COREDUMP_AVAIL)
 > +	    && !(a->flags2 & AF2_COREDUMP_SAVED)
 > +	    && a->fw_coredump_buff) {
 > +		esas2r_read_mem_block(a,
 > +				      a->fw_coredump_buff,
 > +				      MW_DATA_ADDR_SRAM + 0x80000,
 > +				      ESAS2R_FWCOREDUMP_SZ);

Comparing an array (fw_coredump_buff) to null probably isn't what you intended here.

	Dave
