Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3KTRxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:53:11 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53630 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3KTRxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:53:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131120173347.GA2369@hp530>
References: <1384965522-5788-1-git-send-email-ddstreet@ieee.org> <20131120173347.GA2369@hp530>
From: Dan Streetman <ddstreet@ieee.org>
Date: Wed, 20 Nov 2013 12:52:47 -0500
X-Google-Sender-Auth: FE2U8BN_mx7Cf_XJPF41DBvwCKg
Message-ID: <CALZtONA81=R4abFMpMMtDZKQe0s-8+JxvEfZO3NEZ910VwRDmw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: change params from hidden to ro
To: Vladimir Murzin <murzin.v@gmail.com>
Cc: linux-mm@kvack.org, Seth Jennings <sjennings@variantweb.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:33 PM, Vladimir Murzin <murzin.v@gmail.com> wrote:
> Hi Dan!
>
> On Wed, Nov 20, 2013 at 11:38:42AM -0500, Dan Streetman wrote:
>> The "compressor" and "enabled" params are currently hidden,
>> this changes them to read-only, so userspace can tell if
>> zswap is enabled or not and see what compressor is in use.
>
> Could you elaborate more why this pice of information is necessary for
> userspace?

For anyone interested in zswap, it's handy to be able to tell if it's
enabled or not ;-)  Technically people can check to see if the zswap
debug files are in /sys/kernel/debug/zswap, but I think the actual
"enabled" param is more obvious.  And the compressor param is really
the only way anyone from userspace can see what compressor's being
used; that's helpful to know for anyone that might want to be using a
non-default compressor.

And of course, eventually we'll want to make the params writable, so
the compressor can be changed dynamically, and zswap can be enabled or
disabled dynamically (or at least enabled after boot).
