Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbbAWFxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:53:17 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61886 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbAWFxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:53:15 -0500
Date: Fri, 23 Jan 2015 14:53:10 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>, Al Viro <viro@ZenIV.linux.org.uk>,
        Paul Moore <pmoore@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: weird and wrong directory entries
Message-ID: <20150123055310.GA4011@swordfish>
References: <20150123004138.GA2626@swordfish>
 <20150123013053.GY29656@ZenIV.linux.org.uk>
 <20150123020644.GA466@swordfish>
 <54C1C04C.40205@ahsoftware.de>
 <20150123035711.GA462@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123035711.GA462@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/23/15 12:57), Sergey Senozhatsky wrote:
> > Am 23.01.2015 um 03:06 schrieb Sergey Senozhatsky:
> > > On (01/23/15 01:30), Al Viro wrote:
> > >> On Fri, Jan 23, 2015 at 09:42:21AM +0900, Sergey Senozhatsky wrote:
> > >>> Hello gents,
> > >>>
> > >>> I observe this sick behaviour for the past few days. (sorry, some lines are
> > >>> over 80 symbols). all of the things above are happening during kernel compilation.
> > >>> attached .config.
> > >>
> > >>> happens both on reiserfs and ext4, both on current linus's tree and linux-next.
> > >>> no doubt, an attempt to rm -fr pkg/   kills   /usr/, etc.
> > >>>
> > >>
> > >>> I'm puzzled. any thoughts?
> > >>
> > >> Try to bisect, perhaps?
> > >>
> > 
> > There are some weird pieces in the kernel buildsysten which are
> > generating Makefile content based on some filenames and might brake or
> > confuse future builds. See e.g. https://lkml.org/lkml/2014/10/19/10.
> > 
> > Maybe you've stumbled over a similiar thing.
> > 
> 
> Hm, basically, I don't add any new files, especially with commas, etc.,
> just kernel.org vanilla and linux-next.
> 
> 
> things like this:
> 
> $ ll
> ls: cannot access /ho: No such file or directory
> total 12
> d????????? ? ?  ?     ?            ? /ho
> drwxr-xr-x 3 ss ss 4096 Jan 23 08:44 ethernet
> -rw-r--r-- 1 ss ss 3195 Jan 23 08:44 mii.ko.gz
> drwxr-xr-x 2 ss ss 4096 Jan 23 08:44 usb
> 
> make me think that I'm facing a bit different kind of issues.
> 
> gonna bisect for a while. marked Sept 19th tree as good. the issue is not

I meant Jan 19th... apparently, it's january.
good 12ba8571ab6b232f5facef6b1dd28c5ebc2b530a (just randomly picked up).

	-ss

> 100% reproducible, and 1 `ok build' doesn't mean anything. let's see if
> this will fly.
> 
