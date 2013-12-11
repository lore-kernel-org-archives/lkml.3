Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3LKWxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:53:51 -0500
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:35898 "EHLO
	smtp1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750873Ab3LKWxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:53:48 -0500
Message-ID: <52A8ECF5.3070604@in.tum.de>
Date: Wed, 11 Dec 2013 23:53:41 +0100
From: Christian Grothoff <grothoff@in.tum.de>
Organization: TU Munich
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, knock@gnunet.org, jacob@appelbaum.net
Subject: Re: [PATCH] TCP: add option for silent port knocking with integrity
 protection
References: <52A75EF8.3010308@in.tum.de> <20131211.150137.368953964178408437.davem@davemloft.net> <52A8C8B4.4060109@in.tum.de> <20131211122637.75b09074@nehalam.linuxnetplumber.net> <87bo0nulkt.fsf@tassilo.jf.intel.com>
In-Reply-To: <87bo0nulkt.fsf@tassilo.jf.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 10:25 PM, Andi Kleen wrote:
> Stephen Hemminger <stephen@networkplumber.org> writes:
>>
>> The point is that doing it outside of TCP core is safer, less error prone
>> and more flexible.
> 
> Or to put the question differently: what hooks would be needed to make
> this efficiently work in user space?
> 
> It could be something like this: Firewall the port with forwarding the 
> SYN packets using nfqueue, check for the SYN having the right magic,
> change a firewall rule, re-inject using nfqueue (not fully sure how
> well that works)

... and then do the same for the first TCP packet with payload? And you
seriously would consider that "safer" or "less error prone", starting
with the design complexity?  I mean, if this was a patch for GNU Hurd,
I'd at least understand the strong urge to do everything in userspace...
