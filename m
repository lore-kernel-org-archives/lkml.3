Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaBWTwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 14:52:45 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40598 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaBWTwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 14:52:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russ Dill" <Russ.Dill@ti.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Len Brown" <len.brown@intel.com>, "Pavel Machek" <pavel@ucw.cz>,
        "Nicolas Pitre" <nico@linaro.org>,
        "Santosh Shilimkar" <santosh.shilimkar@ti.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        "Cyril Chemparathy" <cyril@ti.com>,
        "Jonathan Austin" <Jonathan.Austin@arm.com>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        "Stephen Boyd" <sboyd@codeaurora.org>
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org>
 <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org>
 <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
 <20140222103840.GH21483@n2100.arm.linux.org.uk>
 <20140222120910.GA9012@e102568-lin.cambridge.arm.com>
Message-ID: <20140223195242.12998.36214@capellas-linux>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
Date: Sun, 23 Feb 2014 11:52:42 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Lorenzo Pieralisi (2014-02-22 04:09:10)
> On Sat, Feb 22, 2014 at 10:38:40AM +0000, Russell King - ARM Linux wrote:
> > On Wed, Feb 19, 2014 at 04:12:54PM +0000, Lorenzo Pieralisi wrote:
> > > > + cpu_switch_mm(idmap_pgd, &init_mm);
> >
> > You need the idmap_pgd in place to call cpu_resume at it's physical
> > address.  Other page tables just won't do here.  It's well established
> > that this page table must be in place for the resume paths to work.
> 
> Well, we do not need idmap page tables for copying the restore_pblist,
> but we do need a set of tables that won't be corrupted by the copy and
> idmap does the trick (I was confused because 1:1 mappings are not needed
> for the copy itself).
> 
> The switch to idmap is done for us in soft_reboot anyway before jumping to
> cpu_resume and that's required, as you said.

Ok, so I'll leave the cpu_switch_mm as is for the next patchset.

Thanks Lorenzo, Russ and Russell!

Sebastian


