Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaIZToz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:44:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54212 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbaIZTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:44:53 -0400
Message-ID: <5425C22F.7050301@gmail.com>
Date: Fri, 26 Sep 2014 13:44:47 -0600
From: David Ahern <lxhacker68@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: nicolas.dichtel@6wind.com, Cong Wang <cwang@twopensource.com>,
        netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>	<54228D87.3070309@6wind.com>	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>	<5422F0F4.6000709@6wind.com>	<CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>	<5423D80B.9060500@6wind.com>	<CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com>	<54256CCB.4000709@6wind.com> <5425BB3E.10700@gmail.com> <87mw9myy4n.fsf@x220.int.ebiederm.org>
In-Reply-To: <87mw9myy4n.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/14, 1:34 PM, Eric W. Biederman wrote:
> When I wrote the "ip netns" support I never expected that all
> applications would want to run in a specific network namespace.  All
> that is needed is one socket per network namespace.

Sure that is another option. But for a process to create a socket or 
thread in a second namespace it has to run as root -- CAP_SYS_ADMIN is 
needed for setns (or perhaps there is another way to create the socket 
or thread in the namespace).

Second, it still does not address the scalability problem. For example a 
single daemon providing service across 2k namespaces means it needs 2k 
listen sockets. From there a system could have 20, 30 or 50 services 
running. Certainly lighter than a process per namespace, but not even 
close to ideal when talking about something like VRFs.

David
