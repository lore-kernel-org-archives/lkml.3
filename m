Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaDVXqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:46:54 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59978 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaDVXqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:46:52 -0400
Date: Tue, 22 Apr 2014 16:46:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "LF.Tan" <lftan.linux@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: min() and max() have warning: comparison of distinct pointer
 types lacks a cast
In-Reply-To: <CAFiDJ58CYnW4fK2iQvXK_8TBgAvTFdfwXx671AHOFT4JK1_COQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404221635480.31560@chino.kir.corp.google.com>
References: <CAFiDJ58CYnW4fK2iQvXK_8TBgAvTFdfwXx671AHOFT4JK1_COQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, LF.Tan wrote:

> Hi all
> 
> Have these warning messages when compiling kernel.
> Anyone know what's wrong?
> 
> Regards.
> ----------------------------
> In file included from mm/readahead.c:10:0:
> mm/readahead.c: In function 'max_sane_readahead':
> include/linux/kernel.h:713:17: warning: comparison of distinct pointer
> types lacks a cast [enabled by default]
>   (void) (&_min1 == &_min2);  \
>                  ^
> mm/readahead.c:242:9: note: in expansion of macro 'min'
>   return min(nr, MAX_READAHEAD);
>          ^
> 

In min(nr, MAX_READAHEAD), nr is of type unsigned long and MAX_READAHEAD 
is of type unsigned long or int depending on the arch.  This warns because 
of strict type-checking, otherwise the results could be unexpected when 
comparing unsigned long to signed long, for example.

I don't think fixing this to do min_t() is the right solution since 
PAGE_SIZE is assumbed to be defined to be ul.  Please send your arch and 
.config.
