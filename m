Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3B1Eng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:43:36 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59017 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3B1Enf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:43:35 -0500
Message-ID: <512EE073.8090709@gmail.com>
Date: Wed, 27 Feb 2013 21:43:31 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130216 Thunderbird/17.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
Subject: Re: [PATCH] perf kvm: fix segfault by initializing file_name to NULL
References: <1362022197-38929-1-git-send-email-dsahern@gmail.com> <512EDD96.9090600@linux.vnet.ibm.com>
In-Reply-To: <512EDD96.9090600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/13 9:31 PM, Xiao Guangrong wrote:
>
> On 02/28/2013 11:29 AM, David Ahern wrote:
>> Dongsoo reported that perf-kvm was segfaulting. The bug was introduced by
>> commit 3786063 which moved file_name from struct perf_kvm which was
>> initialized on the stack to an uninitialized stack variable. Fix by
>> initializing.
>>
>> Needs to be applied to 3.7 and 3.8 as well.
>
> David, The bug has already been fixed by by Arnaldo, see:
> http://git.kernel.org/?p=virt/kvm/kvm.git;a=commit;h=20914ce5b9e1ef4a35f1f09a2c9c8fb8eb1c4d86
>

very odd. Arnaldo's latest perf/urgent has the problem -- and no 
initialized variable. Seems to have been dropped somewhere.

David
