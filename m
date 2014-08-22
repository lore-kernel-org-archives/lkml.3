Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaHVWWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:22:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:64386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaHVWWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:22:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,383,1406617200"; 
   d="scan'208";a="592101473"
Message-ID: <53F7C286.50800@intel.com>
Date: Fri, 22 Aug 2014 15:21:58 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Zhang Zhen <zhenzhang.zhang@huawei.com>
CC: Toshi Kani <toshi.kani@hp.com>, David Rientjes <rientjes@google.com>,
        isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        wangnan0@huawei.com, linux-kernel@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v2] memory-hotplug: add sysfs zones_online_to attribute
References: <1407902811-4873-1-git-send-email-zhenzhang.zhang@huawei.com>	<53EAE534.8030303@huawei.com>	<1408138647.26567.42.camel@misato.fc.hp.com>	<53F17230.5020409@huawei.com> <20140822151622.6786c1089548ea5ceb3732bf@linux-foundation.org>
In-Reply-To: <20140822151622.6786c1089548ea5ceb3732bf@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 03:16 PM, Andrew Morton wrote:
> Also, it's not really clear to me why we need this sysfs file at all. 
> Do people really read sysfs files, make onlining decisions and manually
> type in commands?  Or is this stuff all automated?  If the latter then
> the script can take care of all this?  For example, attempt to online
> the memory into the desired zone and report failure if that didn't
> succeed?

I guess we can just iterate over all possible zone types from userspace
until we find one.  Seems a bit hokey, but it would work at least until
we add a new zone type and we have to teach the scripts about the new
type.  But that's a pretty rare event I guess.  Let's hope the script
writers get this right, and don't make omissions like ZONE_MOVABLE
because it's not that common in practice.
