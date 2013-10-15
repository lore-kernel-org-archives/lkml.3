Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab3JONld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:41:33 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:64493 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3JONlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:41:31 -0400
Date: Tue, 15 Oct 2013 09:40:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2] libahci: fix turning on LEDs in ahci_start_port()
Message-ID: <20131015134058.GF3141@htj.dyndns.org>
References: <20131014161853.20775.1487.stgit@gklab-154-244.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014161853.20775.1487.stgit@gklab-154-244.igk.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 06:18:53PM +0200, Lukasz Dorau wrote:
> If EM Transmit bit is busy during init ata_msleep() is called.
> It is wrong - msleep() should be used instead of ata_msleep(),
> because if EM Transmit bit is busy for one port, it will be busy
> for all other ports too, so using ata_msleep() causes wasting
> tries for another ports.
> 
> The most common scenario looks like that now
> (six ports try to transmit a LED meaasege):
> - port #0 tries for the 1st time and succeeds
> - ports #1-5 try for the 1st time and sleeps
> - port #1 tries for the 2nd time and succeeds
> - ports #2-5 try for the 2nd time and sleeps
> - port #2 tries for the 3rd time and succeeds
> - ports #3-5 try for the 3rd time and sleeps
> - port #3 tries for the 4th time and succeeds
> - ports #4-5 try for the 4th time and sleeps
> - port #4 tries for the 5th time and succeeds
> - port #5 tries for the 5th time and sleeps
> At this moment port #5 wasted all its five tries and failed to initialize.
> Because there are only 5 (EM_MAX_RETRY) tries available usually only five ports
> succeed to initialize. The sixth port and next ones usually will fail.
> 
> If msleep() is used instead of ata_msleep() the first port succeeds to initialize
> in the first try and next ones usually succeed to initialize in the second try.
> 
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>

Applied to libata/for-3.12-fixes with minor updates.

Thanks.

-- 
tejun
