Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaJRLa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 07:30:56 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:40987 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaJRLaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 07:30:55 -0400
Date: Sat, 18 Oct 2014 12:45:25 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
Message-ID: <20141018104525.GA15789@sesse.net>
References: <20141017002132.GA29584@sesse.net>
 <20141017003430.GB29584@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141017003430.GB29584@sesse.net>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 02:34:30AM +0200, Steinar H. Gunderson wrote:
> e341694e3eb57fcda9f1adc7bfea42fe080d8d7a looks like it might cause something
> like this (it certainly added the synchronize_net() call). Cc-ing people on 
> that commit; quoting the entire rest of the message for reference.

I see there's discussion on what to do with this; thanks. :-)

FWIW, I've verified that reverting these four patches (in that order) fixes
the problem:

  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/net/netlink/af_netlink.c?id=9ce12eb16ffb143f3a509da86283ddd0b10bcdb3
  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/net/netlink/af_netlink.c?id=6c8f7e70837468da4e658080d4448930fb597e1b
  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/net/netlink/af_netlink.c?id=67a24ac18b0262178ba9f05501b2c6e6731d449a
  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/net/netlink/af_netlink.c?id=e341694e3eb57fcda9f1adc7bfea42fe080d8d7a

My Perl script is seemingly not the only affected program on the system;
witness the average page load times for our PHP-based home page:

  http://home.samfundet.no/~sesse/web_load_time_samfundet_no-week.png

/* Steinar */
-- 
Homepage: http://www.sesse.net/
