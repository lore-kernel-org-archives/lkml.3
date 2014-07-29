Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaG2ATE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 20:19:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34841 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaG2ATC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 20:19:02 -0400
Date: Mon, 28 Jul 2014 17:19:00 -0700 (PDT)
Message-Id: <20140728.171900.1527499085392907198.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: ryabinin.a.a@gmail.com, a.ryabinin@samsung.com, sasha.levin@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        edumazet@google.com
Subject: Re: net: socket: NULL ptr deref in sendmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406390080.22881.75.camel@localhost>
References: <1406326508.13203.10.camel@localhost>
	<CAPAsAGwc7B2rB+3wTHkL97B5eDchbcuhfkKef56ARCy2CxCGuQ@mail.gmail.com>
	<1406390080.22881.75.camel@localhost>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Jul 2014 17:19:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Sat, 26 Jul 2014 17:54:40 +0200

> On Sa, 2014-07-26 at 19:48 +0400, Andrey Ryabinin wrote:
>> 2014-07-26 2:15 GMT+04:00 Hannes Frederic Sowa <hannes@stressinduktion.org>:
>> > Otherwise I would just set msg_namelen = 0, too, and just not handle
>> > passed in NULL pointers to sockaddrs.
>> >
>> 
>> I like that, how about such chage:
 ...
> LGTM! Can you send a patch?

I definitely agree that we should treat NULL as no address specified.
