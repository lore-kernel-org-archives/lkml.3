Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3G2RnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:43:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47124 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3G2RnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:43:00 -0400
Message-ID: <1375119778.10515.20.camel@edumazet-glaptop>
Subject: Re: A call to revise sockets behaviour
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 29 Jul 2013 10:42:58 -0700
In-Reply-To: <2063167407.40450.1375112877907.JavaMail.mail@webmail09>
References: <2066879158.39771.1375110634453.JavaMail.mail@webmail09>
	<20130729083519.5d574f16@nehalam.linuxnetplumber.net>
	 <2063167407.40450.1375112877907.JavaMail.mail@webmail09>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 15:47 +0000, Artem S. Tashkinov wrote:

> A wine developer clearly showed that this option simply doesn't work. 
> 
> http://bugs.winehq.org/show_bug.cgi?id=26031#c21
> 
> Output of strace:
> getsockopt(24, SOL_SOCKET, SO_REUSEADDR, [0], [4]) = 0
> setsockopt(24, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
> bind(24, {sa_family=AF_INET, sin_port=htons(43012), sin_addr=inet_addr("0.     
> 0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)

Its clear that some other socket did not use SO_REUSADDR

All sockets using a given port _must_ have use SO_REUSADDR to allow this
port being reused.




