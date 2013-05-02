Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab3EBEbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 00:31:43 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:42169 "EHLO
	homiemail-a57.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750766Ab3EBEbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 00:31:41 -0400
Message-ID: <5181EC2B.2030405@shealevy.com>
Date: Thu, 02 May 2013 00:31:39 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 3.8.9 Build Failure in user_namespace.c
References: <af928063831e8eabf1236448484a8a9f@shealevy.com> <20130429205628.GA20607@austin.hallyn.com>
In-Reply-To: <20130429205628.GA20607@austin.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/13 4:56 PM, Serge E. Hallyn wrote:
> Quoting shea@shealevy.com (shea@shealevy.com):
>> Hi All,
>>
>> I just hit the following error trying to build 3.8.9:
>>
>> /nix/store/vkvwpn6f7iff6zqrq2d9z2a1945pcsza-linux-3.8.9-source/kernel/user_namespace.c:
>> In function 'map_write':
>> /nix/store/vkvwpn6f7iff6zqrq2d9z2a1945pcsza-linux-3.8.9-source/kernel/user_namespace.c:582:2:
>> error: implicit declaration of function 'file_ns_capable'
>> [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>>
>> Below is my .config, below that the build log.
> I'm looking at 3.9.  file_ns_capable() is declared in capability.h, which gets
> included into user_namespace.c through cred.h.  I did also try building with
> CONFIG_SECURITY=n and CONFIG_USER_NS=y as you have it, but build succeeded,
> as I would expect given how it is included.

It turned out to be a commit Greg missed in 3.8.9, it was fixed in 3.8.10.

> Do you have any custom patches applied by chance?
>
> -serge

