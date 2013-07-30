Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3G3NDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:03:03 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37618 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3G3NC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:02:56 -0400
Message-ID: <51F7B97B.3010704@gmail.com>
Date: Tue, 30 Jul 2013 22:02:51 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: sunnikrishnan@stec-inc.com, kmo@daterainc.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [RFC] dm-lc target
References: <CABmKtjcsZUbafxtmPb=2-Gkxz9PkFq7KVsQBqRkHduEn7aaqkw@mail.gmail.com> <51F48531.6040104@gmail.com> <20130729143916.GA20119@debian>
In-Reply-To: <20130729143916.GA20119@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comment, Joe.

Yes, dm-lc focuses solely on optimizing writes.

As you know, writing to RAID storage is slower than reading because of
so-called RAID penalty. So, only improving writes may rescue most of the
actual storage systems suffering from heavy I/Os. That's why I cares
writes more than reads.

> The next step is to get some third party users to post their
> experiences with it, and get some feedback on the code itself from
> Mike Snitzer.
Yes, I want to make my code better.

> If I get time I'll integrate it with my test suite.
Thanks. That seems to be a nice test suite.
I am currently testing dm-lc by make -j N and then make test with ruby
source code, but I think the test should be severer.
Actually, I have tried to implement general test tool for block device.
But I gave up.
https://github.com/akiradeveloper/iocheck

Your test suite is like one I have been pursuing.
I am really happy if you integrate dm-lc to your test suite.

Akira

On 7/29/13 11:39 PM, Joe Thornber wrote:
> On Sun, Jul 28, 2013 at 11:42:57AM +0900, Akira Hayakawa wrote:
>> I wrote an introduction slide which is available in URL below:
>> https://github.com/akiradeveloper/dm-lc/blob/develop/what-is-dm-lc.pdf
>> access the page and click "view raw".
> 
> This is nicely orthogonal to dm-cache.
> 
> dm-cache tries to move a working set of fixed size blocks into a cache
> to optimise both read and write.  dm-lc focusses solely on optimising
> bursty writes and uses a journal based structure to accomodate
> variable sized blocks.
> 
> The next step is to get some third party users to post their
> experiences with it, and get some feedback on the code itself from
> Mike Snitzer.
> 
> If I get time I'll integrate it with my test suite.
> 
> https://github.com/jthornber/device-mapper-test-suite
> 
> 
> - Joe
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

