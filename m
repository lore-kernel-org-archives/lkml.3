Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031Ab3JPUrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:47:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:41639 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761077Ab3JPUrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:47:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,508,1378882800"; 
   d="scan'208";a="308742165"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: RE: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Thread-Topic: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Thread-Index: AQHOxk3GSPFKevrviUSFtROVbDKwIZn2dzGAgAABsoCAAAhygIAAePIAgACPTgCAABYRgIAAAd+AgAAUkgCAABvl0A==
Date: Wed, 16 Oct 2013 20:47:05 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D31C65@ORSMSX106.amr.corp.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com> <20131015170039.GF7908@pd.tnic>
 <525D7BCD.7080303@linux.vnet.ibm.com>
 <20131015214346.68718bcd.m.chehab@samsung.com>
 <20131016091640.GA13608@pd.tnic>
 <20131016073539.5a48f65e.m.chehab@samsung.com>
 <20131016104221.GC13608@pd.tnic> <20131016085558.19fe143a@samsung.com>
In-Reply-To: <20131016085558.19fe143a@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, I suspect that, if an error happens to affect more than one DIMM
> (e. g. part of the location is not available for a given error),
> that the DIMM label will also not be properly shown.

There are a couple of cases here:

1) There are a number of DIMMs behind some flaky h/w that introduces errors
that are apparently blamed onto each of those DIMMs.

  All we can do here is statistical correlations ... each error is reported independently,
  it is up to some entity to notice the higher level topology connection. There is enough
  information in the UEFI error record to do that (assuming that BIOS filled out the
  necessary fields).

2) There is a single reported error that spans more than one DIMM.

  This can happen with a UC error in a pair of lock-step DIMMs.  Since the error is UC
  we know that two (or more) bits are bad.  But we have no way to tell whether the
  bad bits came from the same DIMM, or one bit from each (because we don't know
  which bits are bad - if we knew that, we could fix them :-)   The eMCA case should
  log two subsections in this case - one for each of the lockstep DIMMs involved. A user
  seeing this will should probably just replace both DIMMs to be safe.  If they wanted to
  diagnose further they should swap DIMMs around so this pair are no longer lockstepped
  and see if they start seeing correctable errors from each of the split pair - or if the UC
  errors move with one or the other of the DIMMs

-Tony
