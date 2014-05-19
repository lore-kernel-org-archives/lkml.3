Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaESXkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:40:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaESXkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:40:39 -0400
Date: Mon, 19 May 2014 16:40:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 mmots] fs/hfsplus/wrapper.c: replace shift loop by
 fls
Message-Id: <20140519164037.ec6438686bd29efeebffa610@linux-foundation.org>
In-Reply-To: <1400541748.14238.58.camel@joe-AO725>
References: <20140516223815.88ffae2289f969381f176fdc@skynet.be>
	<20140519160946.84e79c832dfc4db0fbae573b@linux-foundation.org>
	<1400541748.14238.58.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 16:22:28 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-05-19 at 16:09 -0700, Andrew Morton wrote:
> > On Fri, 16 May 2014 22:38:15 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> > > Replace while blocksize;shift by fls -1
> []
> > fls() always makes my brain hurt.  ilog() is nicer?
> 
> Maybe take an aspirin?
> 
> ilog2(n) is effectively fls(n) - 1

Precisely.  ilog2() means "integer log 2".  Whereas fls() is some weird
low-level bit-scanning thing.

What we want at this callsite is "integer log 2".  So use it.
