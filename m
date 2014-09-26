Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaIZTPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:15:18 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58869 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbaIZTPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:15:16 -0400
Message-ID: <5425BB3E.10700@gmail.com>
Date: Fri, 26 Sep 2014 13:15:10 -0600
From: David Ahern <lxhacker68@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: nicolas.dichtel@6wind.com, Cong Wang <cwang@twopensource.com>
CC: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>	<5422F0F4.6000709@6wind.com>	<CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>	<5423D80B.9060500@6wind.com> <CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com> <54256CCB.4000709@6wind.com>
In-Reply-To: <54256CCB.4000709@6wind.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/14, 7:40 AM, Nicolas Dichtel wrote:
>>
>>
>> No, I don't want to monitor anything. Even if I wanted, I would just
>> start one
>> daemon in each netns instead of one for all.
> Ok you don't want, but some other people (not only me) want it! And
> having one
> daemon per netns does not scale: there are scenarii with thousand netns
> which
> are dynamically created and deleted.

An example of the scaling problem using quagga (old but still seems to 
be a relevant data point):

 
https://lists.quagga.net/pipermail/quagga-users/2010-February/011351.html

"2k VRFs that would be 2.6G"

And that does not include the overhead of each namespace -- roughly 
200kB/namespace on one kernel I checked (v3.10). So that's a ballpark of 
3G of memory.

David
