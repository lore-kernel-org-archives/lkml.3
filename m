Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab3GWQBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:01:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:9145 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab3GWQBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,728,1367996400"; 
   d="scan'208";a="272122888"
Message-ID: <51EEA89F.9070309@intel.com>
Date: Tue, 23 Jul 2013 09:00:31 -0700
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
References: <1374261785-1615-1-git-send-email-kys@microsoft.com> <20130722123716.GB24400@dhcp22.suse.cz> <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com> <51EEA11D.4030007@intel.com> <3318be0a96cb4d05838d76dc9d088cc0@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <3318be0a96cb4d05838d76dc9d088cc0@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:54 AM, KY Srinivasan wrote:
>> > Adding memory usually requires allocating some large, contiguous areas
>> > of memory for use as mem_map[] and other VM structures.  That's really
>> > hard to do under heavy memory pressure.  How are you accomplishing this?
> I cannot avoid failures because of lack of memory. In this case I notify the host of
> the failure and also tag the failure as transient. Host retries the operation after some
> delay. There is no guarantee it will succeed though.

You didn't really answer the question.

You have allocated some large, physically contiguous areas of memory
under heavy pressure.  But you also contend that there is too much
memory pressure to run a small userspace helper.  Under heavy memory
pressure, I'd expect large, kernel allocations to fail much more often
than running a small userspace helper.

It _sounds_ like you really want to be able to have the host retry the
operation if it fails, and you return success/failure from inside the
kernel.  It's hard for you to tell if running the userspace helper
failed, so your solution is to move what what previously done in
userspace in to the kernel so that you can more easily tell if it failed
or succeeded.

Is that right?
