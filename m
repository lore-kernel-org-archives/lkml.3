Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947440Ab3BICkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 21:40:37 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:48898 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760552Ab3BICkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 21:40:35 -0500
Message-ID: <5115B720.2080207@250bpm.com>
Date: Sat, 09 Feb 2013 03:40:32 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com> <20130207144433.527ef024.akpm@linux-foundation.org> <5114F2D8.5020300@250bpm.com> <20130208222107.GA4762@dcvr.yhbt.net>
In-Reply-To: <20130208222107.GA4762@dcvr.yhbt.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 08/02/13 23:21, Eric Wong wrote:
> Martin Sustrik<sustrik@250bpm.com>  wrote:
>> On 07/02/13 23:44, Andrew Morton wrote:
>>> That's a nice changelog but it omitted a critical thing: why do you
>>> think the kernel needs this feature?  What's the value and use case for
>>> being able to poll these descriptors?
>>
>> To address the question, I've written down detailed description of
>> the challenges of the network protocol development in user space and
>> how the proposed feature addresses the problems.
>>
>> It's too long to fit into ChangeLog, but it may be worth reading
>> when trying to judge the merit of the patch.
>>
>> It can be found here: http://www.250bpm.com/blog:16
>
> Using one eventfd per userspace socket still seems a bit wasteful.

Wasteful in what sense? Occupying a slot in file descriptor table? 
That's the price for having the socket uniquely identified by the fd.

> Couldn't you use a single pipe for all sockets and write the efd_mask to
> the pipe for each socket?
>
> A read from the pipe would behave like epoll_wait.
>
> You might need to use one-shot semantics; but that's probably
> the easiest thing in multithreaded apps anyways.

Having multiple sockets represented by a single eventfd. how would you 
distinguish where did individual events came from?

   struct pollfd pfd;
   ...
   poll (pfd, 1, -1);
   if (pfd.revents & POLLIN) /* Incoming data on which socket? */
     ...

Martin
