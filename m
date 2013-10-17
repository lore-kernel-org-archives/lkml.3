Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3JQNS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:18:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48389 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850Ab3JQNSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:18:24 -0400
Date: Thu, 17 Oct 2013 14:18:21 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, tony.luck@intel.com, tomoki.sekiyama@hds.com,
        dle-develop@lists.sourceforge.net
Subject: Re: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry
 until, the scan is completed
Message-ID: <20131017131821.GH10834@console-pimps.org>
References: <52584373.3010202@hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52584373.3010202@hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct, at 02:29:07PM, Seiji Aguchi wrote:
> Change from v2:
> - Move dynamic memory allocation to efi_pstore_read() before holding
>   efivars->lock to protect entry->var.Data.
> - Access to entry->scanning while holding efivars->lock.
> - Move a comment about a returned value from efi_pstore_read_func() to
>   efi_pstore_read() because "size < 0" case may happen in efi_pstore_read().

It seems to me that because you're no longer dropping __efivars->lock
when reading from the EFI variable store, you actually don't need all
the ->scanning and ->deleting logic because anything that sets those
flags runs to completion while holding the lock.

Can't the patch be simplified to just allocating data.buf at the
beginning of efi_pstore_read()? Also, it would be a good idea to
introduce a #define for the 1024 magic number, e.g.

#define EFIVARS_DATA_SIZE_MAX	1024

-- 
Matt Fleming, Intel Open Source Technology Center
