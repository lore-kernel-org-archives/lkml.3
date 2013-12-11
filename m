Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3LKUTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:19:08 -0500
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:62201 "EHLO
	smtp1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751275Ab3LKUTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:19:06 -0500
Message-ID: <52A8C8B4.4060109@in.tum.de>
Date: Wed, 11 Dec 2013 21:19:00 +0100
From: Christian Grothoff <grothoff@in.tum.de>
Organization: TU Munich
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, knock@gnunet.org,
        jacob@appelbaum.net
Subject: Re: [PATCH] TCP: add option for silent port knocking with integrity
 protection
References: <52A75EF8.3010308@in.tum.de> <20131211.150137.368953964178408437.davem@davemloft.net>
In-Reply-To: <20131211.150137.368953964178408437.davem@davemloft.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 09:01 PM, David Miller wrote:
> From: Christian Grothoff <grothoff@in.tum.de>
> Date: Tue, 10 Dec 2013 19:35:36 +0100
> 
>> Only NAT implementations that change the SQN are not supported
>> (those should be rare, but we have no hard data on this).
> 
> Even Linux's netfilter can and does do this, it is absolutely necessary
> for tracking SIP and FTP protocols, and it's also used in our virtual
> server load balancing modules.
> 

We're aware that Linux _can_ do this.  I was not aware it was doing this
for
SIP and FTP specifically; regardless, what implementations can do is less
important than what they are configured to do most of the time, and that's
what we'd need hard data on.  Anyway, I'd be very interested to learn how
you use this for SIP/FTP to evaluate the impact.  Do you have documentation
on this?

As for server load balancing, I suspect that those are not the kinds of
services that one would typically use port knocking for.  Still, again a
good hint as to where trouble might lurk (and we will definitively include
those points in the next revision of the documentation).
