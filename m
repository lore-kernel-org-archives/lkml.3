Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaFXR4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:56:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:42539 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbaFXR4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:56:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,539,1400050800"; 
   d="scan'208";a="552665821"
From: "Luck, Tony" <tony.luck@intel.com>
To: Daniel Kiper <daniel.kiper@oracle.com>, Jan Beulich <JBeulich@suse.com>
CC: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "eshelton@pobox.com" <eshelton@pobox.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: RE: [PATCH v6 1/9] efi: Use early_mem*() instead of early_io*()
Thread-Topic: [PATCH v6 1/9] efi: Use early_mem*() instead of early_io*()
Thread-Index: AQHPjurJMvi1kjppck6FTiWu5qFFH5uAjAbw
Date: Tue, 24 Jun 2014 17:56:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F32846B97@ORSMSX114.amr.corp.intel.com>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
 <1403299768-9955-2-git-send-email-daniel.kiper@oracle.com>
 <53A7F104020000780001C4BE@mail.emea.novell.com>
 <20140623135446.GG28489@olila.local.net-space.pl>
In-Reply-To: <20140623135446.GG28489@olila.local.net-space.pl>
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

> I am CC'ing IA-64 guys.

The *_unmap() functions are no-op on ia64 - because we have mappings for everything all the time
- the *_map() functions just need to compute the proper address to use to get the right attributes
(so we don't mix and match cacheable and uncachable access to the same address). But there is
nothing to tear down afterwards.

I do tend to agree with Daniel that is seems odd to setup the mapping with one class of function
and then tear it down with another.

-Tony

