Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3JGIMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:12:20 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:36386 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3JGIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <20131007051038.GA9764@localhost>
References: <20131006082340.GA24568@localhost>
	<CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
	<20131007021118.GA27927@localhost>
	<20131007051038.GA9764@localhost>
Date: Mon, 7 Oct 2013 01:12:17 -0700
X-Google-Sender-Auth: DYFt-MDPJPcy5Iw0IuRqEwjD_zw
Message-ID: <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 6, 2013 at 10:10 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> I retried bisect with "Oops:" and the first bad commit is
>
> commit c817a67ecba7c3 ("kobject: delayed kobject release: help find buggy drivers")

Ok, that makes way more sense.

> That commit has already helped expose some bugs, however I suspect there are
> still many hidden ones. In this particular bisect, the commit produces 85 good
> dmesgs and 2055 bad dmesgs, exposing all sorts of error messages
>
>    1929 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>    1921 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>    1897 Kernel panic - not syncing: Fatal exception in interrupt
..

Ok, can you post some of the more promising oopses so that we can try
to figure out what kobject it is that causes problems?

              Linus
