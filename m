Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162341Ab3DERy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:54:29 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:33628 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162288Ab3DERy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130405174828.310a02c3@trediske.ws.office.manitu.net>
References: <20130405174828.310a02c3@trediske.ws.office.manitu.net>
Date: Fri, 5 Apr 2013 13:54:26 -0400
Message-ID: <CADVnQy=Hs62x646Ece1hD79bTHSnsH9C0Whwo13zXU1S3kTYrQ@mail.gmail.com>
Subject: Re: PROBLEM: IPv6 TCP-Connections resetting
From: Neal Cardwell <ncardwell@google.com>
To: Tetja Rediske <tetja@tetja.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 11:48 AM, Tetja Rediske <tetja@tetja.de> wrote:
> I tracked it down with 'git bisect' to commit:
>
>   093d04d42fa094f6740bb188f0ad0c215ff61e2c
...

Thanks for the  detailed report!

> 11:52:04.634656 IP6 fe80::92e2:baff:fe00:c120 > 2a00:1828:1000:1102::2:
> ICMP6, redirect, 2a00:1828:0:1::10 to 2a00:1828:0:1::10, length 136

Would you be able to re-run your tests with a tcpdump command line like:

  tcpdump -v -n -X -s 1600 icmp6

And report the full dump of this first ICMP6 packet in the exchange?

It seems that perhaps the parsing/validation of this packet is failing
somehow, so it would be nice to know exactly what that packet looked
like.

Also, are both sides of your test running 3.9.0-rc5+?

And can you please cc netdev@vger.kernel.org if you follow up with more details?

Thanks!
neal
