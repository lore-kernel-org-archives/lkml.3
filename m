Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3BIHgP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 02:36:15 -0500
Received: from chrocht.moloch.sk ([62.176.169.44]:49129 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3BIHgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 02:36:13 -0500
Message-ID: <5115FC6A.8000603@250bpm.com>
Date: Sat, 09 Feb 2013 08:36:10 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com> <20130207144433.527ef024.akpm@linux-foundation.org> <5114F2D8.5020300@250bpm.com> <20130208222107.GA4762@dcvr.yhbt.net> <5115B720.2080207@250bpm.com> <20130209035431.GA28448@dcvr.yhbt.net>
In-Reply-To: <20130209035431.GA28448@dcvr.yhbt.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/13 04:54, Eric Wong wrote:

>>> Using one eventfd per userspace socket still seems a bit wasteful.
>>
>> Wasteful in what sense? Occupying a slot in file descriptor table?
>> That's the price for having the socket uniquely identified by the
>> fd.
>
> Yes.  I realize eventfd is small, but I don't think eventfd is needed
> at all, here.  Just one pipe.

Ah. Got you! You mean not to change the kernel, just use pipe for the 
purpose.

However, the convoluted pipe-style design is the problem I am trying to 
solve rather than the solution. It leads to convoluted APIs with 
convoluted semantics as described in the article. I've been using that 
kind of design for past 8 years and every time I have to deal with it I 
swear that one day I will implement a proper in-kernel solution to get 
rid of the hack.

And now I have finally done so.

Martin
