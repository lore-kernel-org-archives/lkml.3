Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3GWP2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:28:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:61397 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab3GWP2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:28:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,728,1367996400"; 
   d="scan'208";a="369717962"
Message-ID: <51EEA11D.4030007@intel.com>
Date: Tue, 23 Jul 2013 08:28:29 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Michal Hocko <mhocko@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kay@vrfy.org" <kay@vrfy.org>
Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
References: <1374261785-1615-1-git-send-email-kys@microsoft.com> <20130722123716.GB24400@dhcp22.suse.cz> <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 07:52 AM, KY Srinivasan wrote:
>  The current scheme of involving user
> level code to close this loop obviously does not perform well under high memory pressure.

Adding memory usually requires allocating some large, contiguous areas
of memory for use as mem_map[] and other VM structures.  That's really
hard to do under heavy memory pressure.  How are you accomplishing this?

