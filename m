Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3FQSCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:02:16 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:39729 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab3FQSB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:01:57 -0400
Date: Mon, 17 Jun 2013 11:01:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Matthew Garrett <mjg@redhat.com>, Aaron Lu <aaron.lu@intel.com>
Cc: Liu Jiang <liuj97@gmail.com>, Liu Jiang <liu97@gmail.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
Message-ID: <20130617180151.GG32663@mtj.dyndns.org>
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com>
 <51BE6B5C.70803@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BE6B5C.70803@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 09:50:20AM +0800, Aaron Lu wrote:
> On 06/15/2013 11:02 AM, Liu Jiang wrote:
> > From: Liu Jiang <liu97@gmail.com>
> > 
> > Commit 30dcf76acc69 "libata: migrate ACPI code over to new bindings"
> > removed ACPI dock notification related code, but there's some dead
> > code left, so clean up it.
> 
> I never noticed this, but it looks to be the case...
> 
> I'm not sure the dock notification code is removed intentionally or
> mistakenly though, if it is a mistake, then instead of removing the left
> code here, we probably should add the dock notification code back.
> 
> But I have no test system or any knowledge about how ata dock works, so
> I may be wrong :-)

Looks like a regression to me.  We're probably locking up on some
older laptops which connects optical drives with hotpluggable PATA.
Matthew, can you please fix it?

Thanks.

-- 
tejun
