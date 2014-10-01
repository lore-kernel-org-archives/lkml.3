Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaJAPbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:31:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaJAPbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:31:14 -0400
Date: Wed, 1 Oct 2014 16:39:58 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20141001153958.GF8971@agordeev.usersys.redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
 <20141001153114.GE8971@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20141001153114.GE8971@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2014 at 04:31:14PM +0100, Alexander Gordeev wrote:
> I am attaching excerpts from some new perf tests I have done (this

Attaching :)

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="perf.hist.0-3.16.0.txt"

  0.04%     dd  [kernel.kallsyms]  [k] ata_std_qc_defer
  0.04%     dd  [kernel.kallsyms]  [k] ata_scsi_rw_xlat
  0.03%     dd  [kernel.kallsyms]  [k] ata_scsi_queuecmd
  0.03%     dd  [kernel.kallsyms]  [k] __ata_scsi_find_dev
  0.02%     dd  [kernel.kallsyms]  [k] ata_scsi_translate
  0.02%     dd  [kernel.kallsyms]  [k] ata_qc_new_init
  0.02%     dd  [kernel.kallsyms]  [k] ata_scsi_qc_complete
  0.02%     dd  [kernel.kallsyms]  [k] ata_build_rw_tf
  0.01%     dd  [kernel.kallsyms]  [k] ata_qc_issue
  0.01%     dd  [kernel.kallsyms]  [k] ata_sg_init
  0.00%     dd  [kernel.kallsyms]  [k] ata_tf_to_fis
  0.00%     dd  [kernel.kallsyms]  [k] ata_qc_complete_multiple
  0.00%     dd  [kernel.kallsyms]  [k] __ata_qc_complete
  0.00%     dd  [kernel.kallsyms]  [k] ata_qc_complete
  0.00%     dd  [kernel.kallsyms]  [k] ata_scsi_find_dev
  0.00%     dd  [kernel.kallsyms]  [k] ata_qc_free
  0.04%     dd  [kernel.kallsyms]  [k] ahci_interrupt
  0.02%     dd  [kernel.kallsyms]  [k] ahci_qc_issue
  0.02%     dd  [kernel.kallsyms]  [k] ahci_qc_prep
  0.02%     dd  [kernel.kallsyms]  [k] ahci_scr_read
  0.01%     dd  [kernel.kallsyms]  [k] ahci_handle_port_interrupt
  0.01%     dd  [kernel.kallsyms]  [k] ahci_pmp_qc_defer
  0.00%     dd  [kernel.kallsyms]  [k] ahci_scr_write

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="perf.hist.0-3.16.0.opt-intr.txt"

  0.04%     dd  [kernel.kallsyms]  [k] ata_scsi_queuecmd
  0.03%     dd  [kernel.kallsyms]  [k] ata_scsi_rw_xlat
  0.03%     dd  [kernel.kallsyms]  [k] ata_scsi_translate
  0.03%     dd  [kernel.kallsyms]  [k] ata_qc_new_init
  0.02%     dd  [kernel.kallsyms]  [k] ata_build_rw_tf
  0.02%     dd  [kernel.kallsyms]  [k] ata_qc_issue
  0.01%     dd  [kernel.kallsyms]  [k] ata_sg_init
  0.01%     dd  [kernel.kallsyms]  [k] ata_std_qc_defer
  0.01%     dd  [kernel.kallsyms]  [k] ata_tf_to_fis
  0.00%     dd  [kernel.kallsyms]  [k] ata_scsi_find_dev
  0.00%     dd  [kernel.kallsyms]  [k] __ata_scsi_find_dev
  0.02%     dd  [kernel.kallsyms]  [k] ahci_qc_prep
  0.02%     dd  [kernel.kallsyms]  [k] ahci_qc_issue
  0.01%     dd  [kernel.kallsyms]  [k] ahci_pmp_qc_defer

--C7zPtVaVf+AK4Oqc--
