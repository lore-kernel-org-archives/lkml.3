Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3A3QtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:49:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47398 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3A3QtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:49:23 -0500
Message-ID: <51094F10.60605@wwwdotorg.org>
Date: Wed, 30 Jan 2013 09:49:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] nl80211: avoid "wdev_id may be used uninitialized"
References: <1359504662-23561-1-git-send-email-swarren@wwwdotorg.org>  (sfid-20130130_011118_335925_03B80596) <1359532679.8010.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359532679.8010.1.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 12:57 AM, Johannes Berg wrote:
> On Tue, 2013-01-29 at 17:11 -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Silence the following:
>> net/wireless/nl80211.c: In function '__cfg80211_wdev_from_attrs.clone.119':
>> net/wireless/nl80211.c:57:6: warning: 'wdev_id' may be used uninitialized in this function
>>
>> ... by always initializing wdev_id to zero. I assume that wiphy_idx and
>> ifidx are set to -1 for similar reasons, so this change simply propagates
>> the same workaround.
>>
>> In practice, this warning is false, since wdev_id is both set and used
>> under the condition if (have_wdev_id). However, at least my compiler
>> can't be coerced into realizing this; almost any code between the if
>> blocks that set and use the variable causes this warning.
> 
> I don't see this warning? What compiler are you using?

I'm using gcc-4.5.3 for ARM. I checked with gcc-4.6.3 and gcc-4.7.2 and
indeed I don't see the warning there.

