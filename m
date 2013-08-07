Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3HGDyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:54:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24278 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3HGDyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:54:20 -0400
X-Spam-Score: -100.8
Message-ID: <5201C4AB.4070309@asianux.com>
Date: Wed, 07 Aug 2013 11:53:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value
 'result'
References: <5200A5E6.9020803@asianux.com>  <20130806144339.182beb0a2abddc0782015487@linux-foundation.org> <1375827089.2424.37.camel@joe-AO722>
In-Reply-To: <1375827089.2424.37.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:11 AM, Joe Perches wrote:
> On Tue, 2013-08-06 at 14:43 -0700, Andrew Morton wrote:
>> On Tue, 06 Aug 2013 15:29:42 +0800 Chen Gang <gang.chen@asianux.com> wrote:
>>
>>> Improve the usage of return value 'result', so not only can make code
>>> clearer to readers, but also can improve the performance.
>>
>> It used to be pervasive kernel style do to
>>
>> 	ret = -ENOMEM;
>> 	foo = alloc(...);
>> 	if (!foo)
>> 		goto out;
>>
>> whereas nowadays people usually do the more straightforward
>>
>> 	foo = alloc(...);
>> 	if (!foo) {
>> 		ret = -ENOMEM;
>> 		goto out;
>> 	}
>>
>> The thinking was that the old style generated better code, but for the
>> life of me I can't remember why :(
> 
> https://lkml.org/lkml/2008/12/16/383
> 

Thank you for your information.

-- 
Chen Gang
