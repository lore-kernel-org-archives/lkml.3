Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3J3Off (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:35:35 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48069 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962Ab3J3Ofe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:35:34 -0400
Date: Wed, 30 Oct 2013 14:35:27 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry
 until, the scan is completed
Message-ID: <20131030143527.GB8193@console-pimps.org>
References: <52584373.3010202@hds.com>
 <20131017131821.GH10834@console-pimps.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443F0F2D6@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443F0F2D6@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct, at 10:30:58PM, Seiji Aguchi wrote:
> The scanning and deleting logic is still needed.  In case an entry(A)
> is found, the pointer is saved to psi->data.  And efi_pstore_read()
> passes the entry(A) to a pstore filesystem by releasing
> __efivars->lock.
> 
> And then, the pstore filesystem calls efi_pstore_read() again and the
> same entry(A), which is saved to psi->data, is used for re-scanning a
> sysfs-list.  (That is why list_for_each_entry_safe_from () is used in
> efi_pstore_sysfs_entry_iter().)
> 
> So, to protect the entry(A), the logic is needed because, in pstore
> filesystem,  __efivars->lock Is released. 
 
Very good point.

-- 
Matt Fleming, Intel Open Source Technology Center
