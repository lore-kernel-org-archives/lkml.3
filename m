Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaETFCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:02:45 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:14444 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbaETFCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:02:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoVANzgelNXQzEi/2dsb2JhbABZgwarBwEBAQUBmiUCAgGBFBd0giUBAQQBOhwjBQsIAxguOR4GE4g5DAHSSxeFVYh5B4RAAQOZXwGTHYM6Ow
Date: Tue, 20 May 2014 07:02:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 mmots] fs/hfsplus/wrapper.c: replace shift loop by
 fls
Message-Id: <20140520070243.6fdb8ec2bbcc105fed0ae7ea@skynet.be>
In-Reply-To: <1400543405.19786.4.camel@joe-AO725>
References: <20140516223815.88ffae2289f969381f176fdc@skynet.be>
	<20140519160946.84e79c832dfc4db0fbae573b@linux-foundation.org>
	<1400541748.14238.58.camel@joe-AO725>
	<20140519164037.ec6438686bd29efeebffa610@linux-foundation.org>
	<1400543405.19786.4.camel@joe-AO725>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 16:50:05 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-05-19 at 16:40 -0700, Andrew Morton wrote:
> > On Mon, 19 May 2014 16:22:28 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > On Mon, 2014-05-19 at 16:09 -0700, Andrew Morton wrote:
> > > > On Fri, 16 May 2014 22:38:15 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> > > > > Replace while blocksize;shift by fls -1
> > > []
> > > > fls() always makes my brain hurt.  ilog() is nicer?
> > > Maybe take an aspirin?
> > > ilog2(n) is effectively fls(n) - 1
> > Precisely.  ilog2() means "integer log 2".  Whereas fls() is some weird
> > low-level bit-scanning thing.
> 
> <shrug>  find-last[bit]-set is pretty obvious to me.
> ilog2(n) makes me think just a little more.
> 
> > What we want at this callsite is "integer log 2".  So use it.
> 
> Same thing.  Same ratio of use too.
> 
> $ git grep -w fls | wc -l
> 457
> $ git grep -w ilog2 | wc -l
> 391
and the winner is ? :)
> 
> 
