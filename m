Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934905AbaKNAlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:41:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:20944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934594AbaKNAlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:41:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,381,1413270000"; 
   d="scan'208";a="636701384"
From: "Vick, Matthew" <matthew.vick@intel.com>
To: Joe Stringer <joestringer@nicira.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "therbert@google.com" <therbert@google.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 net 1/2] fm10k: Check tunnel header length in encap
 offload
Thread-Topic: [PATCHv2 net 1/2] fm10k: Check tunnel header length in encap
 offload
Thread-Index: AQHP/5rmFBnfUvUdLESFE0d7q81MgJxfSCEA
Date: Fri, 14 Nov 2014 00:41:03 +0000
Message-ID: <D08A8E37.5FC83%matthew.vick@intel.com>
References: <1415921801-10452-1-git-send-email-joestringer@nicira.com>
In-Reply-To: <1415921801-10452-1-git-send-email-joestringer@nicira.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.4.140807
x-originating-ip: [10.255.79.154]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3C98F8173339741B19C66116CD34D3A@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14, 3:36 PM, "Joe Stringer" <joestringer@nicira.com> wrote:

>fm10k supports up to 184 bytes of inner+outer headers. Add an initial
>check to fail encap offload if these are too large.
>
>Signed-off-by: Joe Stringer <joestringer@nicira.com>
>---
>Matthew, I didn't see the equivalent patch on netdev so I went ahead and
>created it. If I've missed this somewhere, then please disregard.
>
>v2: First post.

You didn't miss it Joe--it just hasn't made it up yet. :) It's currently
in Jeff's tree for testing. You're on the CC for the patch, so you'll get
a notification once it goes up. It's basically the same as what you have,
except the #define I use is 184 and I use inner_tcp_hdrlen() to account
for the inner TCP header length.

Since your second patch should apply cleanly on top of mine, what do you
think about dropping the first patch in this series and Jeff can send our
two patches up together once they've passed testing?

Cheers,
Matthew

