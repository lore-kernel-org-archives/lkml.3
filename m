Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbaJUN0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:26:09 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:37344 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaJUN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:26:07 -0400
Date: Tue, 21 Oct 2014 15:25:57 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
Message-ID: <20141021132557.GA9440@sesse.net>
References: <20141017002132.GA29584@sesse.net>
 <20141017003430.GB29584@sesse.net>
 <20141017062517.GA11584@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141017062517.GA11584@casper.infradead.org>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 07:25:17AM +0100, Thomas Graf wrote:
> I think the only option at this point is to re-add the nltable lock to
> netlink_lookup() so we can drop the synchronize_net() until we find a
> way to RCUify socket destruction. I will cook up a patch today unless
> somebody can come up with a smarter way to work around needing the
> synchronize_net().

Did you end up with a patch? We'd like to reboot the server in question
soon-ish, but it's an open question whether we should go to 3.16.x, revert
exactly the patches in question or something else.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
