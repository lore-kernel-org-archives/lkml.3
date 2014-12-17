Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaLQBPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:15:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30245 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaLQBP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:15:29 -0500
Message-ID: <5490D920.5000104@oracle.com>
Date: Tue, 16 Dec 2014 20:15:12 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: net: integer overflow in ip_idents_reserve
References: <5490A1F8.6020207@oracle.com> <1418766460.9773.48.camel@edumazet-glaptop2.roam.corp.google.com> <1418771356.3449499.203748285.4B1A82B8@webmail.messagingengine.com>
In-Reply-To: <1418771356.3449499.203748285.4B1A82B8@webmail.messagingengine.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 06:09 PM, Hannes Frederic Sowa wrote:
> 
> On Tue, Dec 16, 2014, at 22:47, Eric Dumazet wrote:
>> > On Tue, 2014-12-16 at 16:19 -0500, Sasha Levin wrote:
>>> > > Hi Eric,
>>> > > 
>>> > > While fuzzing with trinity on a -next kernel with the undefined behaviour
>>> > > sanitizer path, I've observed the following warning in code which was
>>> > > introduced in 04ca6973f7 ("ip: make IP identifiers less predictable"):
>> > 
>> > This is a false positive.
> Also we compile the whole kernel with -fno-strict-overflow, so every
> report of signed overflow leading to undefined behavior is probably a
> false positive. I don't know if it is worth to try to get rid of them, I
> doubt it.

I reported this one because there's usually some code to handle overflow
in code that expects that and here there was none (I could see).

For example, the ntp code had a few cases where a user could generate
overflows and mess up quite a few things (he got what he asked for -
problems).


Thanks,
Sasha
