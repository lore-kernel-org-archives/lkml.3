Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaFFVfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:35:30 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:64054 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaFFVf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140606155126.27059.76543.stgit@viggo.jf.intel.com>
References: <20140606155126.27059.76543.stgit@viggo.jf.intel.com>
Date: Fri, 6 Jun 2014 14:35:26 -0700
X-Google-Sender-Auth: uBFJD0dkhuewx7oyNNeQjf__Y9k
Message-ID: <CAA9_cmc4oi6S2dzngiMy0TnX1QW_Xcf6nwU6AS_XH=8iaMtmBg@mail.gmail.com>
Subject: Re: [boot regression PATCH] libata: allow xgene-ahci to opt-out of
 tag ordered submission
From: Dan Williams <dan.j.williams@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>, stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Loc Ho <lho@apm.com>, Suman Tripathi <stripathi@apm.com>,
        Tuan Phan <tphan@apm.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 8:52 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Ming Lei reports:
>   "Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
>    controllers) causes below sata failure on APM AHCI controller.
>
>    And the error does disappear after reverting the commit.
>
>      ata4.00: exception Emask 0x40 SAct 0xff00 SErr 0x800 action 0x6 frozen
>      ata4: SError: { HostInt }
>      ata4.00: failed command: READ FPDMA QUEUED
>      ata4.00: cmd 60/08:40:e0:a4:88/00:00:04:00:00/40 tag 8 ncq 4096 in
>               res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x44 (timeout)"
>
> http://marc.info/?l=linux-kernel&m=140195842716315&w=2
>
> Maintain tag ordered submission as the default, but allow xgene-ahci to
> continue with the old behavior.
>
> Cc: Loc Ho <lho@apm.com>
> Cc: <stable@vger.kernel.org>
> Cc: Tuan Phan <tphan@apm.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Suman Tripathi <stripathi@apm.com>
> Cc: Ed Ciechanowski <ed.ciechanowski@intel.com>
> Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Tested-by: Ming Lei <ming.lei@canonical.com>
> Reported-by: Ming Lei <ming.lei@canonical.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Hold off on this as it appears an ahci_xgene fix is on its way.
