Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbaEGNSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:18:44 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41315 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbaEGNSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:18:40 -0400
Date: Wed, 7 May 2014 09:18:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Joe Thomas <Joe.Thomas@dothill.com>
Subject: Re: [PATCH] libata: clean up ZPODD when a port is detached
Message-ID: <20140507131836.GD16702@htj.dyndns.org>
References: <1399384668-20394-1-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399384668-20394-1-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 03:57:48PM +0200, Levente Kurusa wrote:
> When a ZPODD device is unbound via sysfs, the ACPI notify handler
> is not removed. This causes panics as observed in Bug #74601. The
> panic only happens when the wake happens from outside the kernel
> (i.e. inserting a media or pressing a button). Add a loop to
> ata_port_detach which loops through the port's devices and checks
> if zpodd is enabled, if so call zpodd_exit.
> 
> Cc: stable@vger.kernel.org
> Reviewed-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Levente Kurusa <levex@linux.com>

Applied to libata/for-3.15-fixes.

Thanks.

-- 
tejun
