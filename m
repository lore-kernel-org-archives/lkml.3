Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab3JPHKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:10:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:23802 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3JPHKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,505,1378882800"; 
   d="scan'208";a="308393428"
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
To: Tejun Heo <tj@kernel.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2] libahci: fix turning on LEDs in ahci_start_port()
Thread-Topic: [PATCH 2] libahci: fix turning on LEDs in ahci_start_port()
Thread-Index: AQHOyaxG8v8QNV9jz0G11BW/dEtwX5n26ftA
Date: Wed, 16 Oct 2013 07:10:03 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A664B58@IRSMSX105.ger.corp.intel.com>
References: <20131014161853.20775.1487.stgit@gklab-154-244.igk.intel.com>
 <20131015134058.GF3141@htj.dyndns.org>
In-Reply-To: <20131015134058.GF3141@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 15, 2013 3:41 PM Tejun Heo <tj@kernel.org> wrote:
> On Mon, Oct 14, 2013 at 06:18:53PM +0200, Lukasz Dorau wrote:
> > If EM Transmit bit is busy during init ata_msleep() is called.
> > It is wrong - msleep() should be used instead of ata_msleep(), because
> > if EM Transmit bit is busy for one port, it will be busy for all other
> > ports too, so using ata_msleep() causes wasting tries for another
> > ports.
> >
> > The most common scenario looks like that now (six ports try to
> > transmit a LED meaasege):
> > - port #0 tries for the 1st time and succeeds
> > - ports #1-5 try for the 1st time and sleeps
> > - port #1 tries for the 2nd time and succeeds
> > - ports #2-5 try for the 2nd time and sleeps
> > - port #2 tries for the 3rd time and succeeds
> > - ports #3-5 try for the 3rd time and sleeps
> > - port #3 tries for the 4th time and succeeds
> > - ports #4-5 try for the 4th time and sleeps
> > - port #4 tries for the 5th time and succeeds
> > - port #5 tries for the 5th time and sleeps At this moment port #5
> > wasted all its five tries and failed to initialize.
> > Because there are only 5 (EM_MAX_RETRY) tries available usually only
> > five ports succeed to initialize. The sixth port and next ones usually will fail.
> >
> > If msleep() is used instead of ata_msleep() the first port succeeds to
> > initialize in the first try and next ones usually succeed to initialize in the second
> try.
> >
> > Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> 
> Applied to libata/for-3.12-fixes with minor updates.
> 
> Thanks.
> 
Thanks.

Lukasz

