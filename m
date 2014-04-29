Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012AbaD2TEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:04:39 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:58200 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482AbaD2TEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:04:37 -0400
Message-ID: <535FF597.8040109@vmware.com>
Date: Tue, 29 Apr 2014 20:55:19 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/2 with seqcount v3] reservation: add suppport for
 read-only access using rcu
References: <20140409144239.26648.57918.stgit@patser> <20140409144831.26648.79163.stgit@patser> <53465A53.1090500@vmware.com> <53466D63.8080808@canonical.com> <53467B93.3000402@vmware.com> <5346B212.8050202@canonical.com> <5347A9FD.2070706@vmware.com> <5347B4E5.6090901@canonical.com> <5347BFC9.3020503@vmware.com> <53482FF1.1090406@canonical.com> <534843EA.6060602@vmware.com> <534B9165.4000101@canonical.com> <534B921B.4080504@vmware.com> <5357A0DE.7030305@canonical.com> <535FB808.3060608@canonical.com>
In-Reply-To: <535FB808.3060608@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 04:32 PM, Maarten Lankhorst wrote:
> op 23-04-14 13:15, Maarten Lankhorst schreef:
>> This adds 4 more functions to deal with rcu.
>>
>> reservation_object_get_fences_rcu() will obtain the list of shared
>> and exclusive fences without obtaining the ww_mutex.
>>
>> reservation_object_wait_timeout_rcu() will wait on all fences of the
>> reservation_object, without obtaining the ww_mutex.
>>
>> reservation_object_test_signaled_rcu() will test if all fences of the
>> reservation_object are signaled without using the ww_mutex.
>>
>> reservation_object_get_excl() is added because touching the fence_excl
>> member directly will trigger a sparse warning.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> ---
>> Using seqcount and fixing some lockdep bugs.
>> Changes since v2:
>> - Fix some crashes, remove some unneeded barriers when provided by
>> seqcount writes
>> - Fix code to work correctly with sparse's RCU annotations.
>> - Create a global string for the seqcount lock to make lockdep happy.
>>
>> Can I get this version reviewed? If it looks correct I'll mail the
>> full series
>> because it's intertwined with the TTM conversion to use this code.
> Ping, can anyone review this?

Hi, Maarten.
It's on my todo-list. Been away from office for a while.

/Thomas
