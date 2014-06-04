Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaFDWOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:14:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:23164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaFDWOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:14:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,975,1392192000"; 
   d="scan'208";a="542593747"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Joe Perches <joe@perches.com>
CC: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux NICS <Linux-nics@isotope.jf.intel.com>
Subject: Re: [E1000-devel] [PATCH] net: ethernet: intel: ixgbe:
 ixgbe_main.c: Cleaning up missing null-terminate after strncpy call
Thread-Topic: [E1000-devel] [PATCH] net: ethernet: intel: ixgbe:
 ixgbe_main.c: Cleaning up missing null-terminate after strncpy call
Thread-Index: AQHPgD/g1jrh158h6UGQxnT2rTe8NZth+XAA
Date: Wed, 4 Jun 2014 22:14:05 +0000
Message-ID: <21D85D78-EB7B-4C74-861B-43D7EDE350F7@intel.com>
References: <1401917380-2772-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1401918909.26329.5.camel@joe-AO725>
In-Reply-To: <1401918909.26329.5.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.24.122]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0FE3CB483B5B74BB5DD7066F205CD2C@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 4, 2014, at 2:55 PM, Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-06-04 at 23:29 +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
> 
> Perhaps all of these should be strlcpy

The code that is there seems fine. The length of the array exceeds the length of the literal, and the strncpy ensures that the entire buffer is initialized so no information can possibly leak from the kernel.

I think this is fine as it is without any patch.

-- 
Mark Rustad, Networking Division, Intel Corporation

