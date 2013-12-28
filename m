Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3L1Mgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 07:36:42 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:59875 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313Ab3L1Mgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 07:36:40 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsSAAXFvlJbsn23/2dsb2JhbABYKIJjumQCAoEUF3SCJQEBAQMBOhwjBQsIAw4KLjkeBhOHfAwByTwXjx0HhDYBA4lBjlUBkhSDOi8
Date: Sat, 28 Dec 2013 12:37:38 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] selftests : Adding symbolic link limits test script
Message-Id: <20131228123738.962401ca9282626693aba5bf@skynet.be>
In-Reply-To: <20131227143822.2b2a8bc448fb7e0800f05f53@linux-foundation.org>
References: <20131225172310.6eb4aa79f79a9fa5a79b3f4e@skynet.be>
	<20131227143822.2b2a8bc448fb7e0800f05f53@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Dec 2013 14:38:22 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Dec 2013 17:23:10 +0100 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > This patch adds fs directory in selftests and a script to explain recursive
> > and consecutive symbolic linking limits who have been debated
> > so many times.
> 
> hm, it's a "test" which doesn't really test anything - it always
> succeeds.
> 
> Why do you think the kernel needs this?

Thanks for testing Andrew !

As the script states, first loop is trying 10 recursive links but logically stops at 8.
The second one is trying 50 consecutive links but stops at 40.
Those limits are hardcoded values all over the place in vfs namei.c.
btw people have been asking for global definition, sysctl and so on for
years but nothing has changed AFAICS.

This script tries to show the difference between recursive and consecutive symlinking.
Besides this script could be useful for testing specific FS limitation as well.
If you find it useful, I can add some features to be more self-explanatory ...
If it's still not the case let's forget about it :) 

Fabian
