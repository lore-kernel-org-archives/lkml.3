Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3GXQXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:23:38 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:63653 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3GXQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130724160826.GD24851@moon>
References: <20130724160826.GD24851@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Jul 2013 09:23:14 -0700
Message-ID: <CALCETrXYnkonpBANnUuX+aJ=B=EYFwecZO27yrqcEU8WErz9DA@mail.gmail.com>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 9:08 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Andy Lutomirski reported that in case if a page with _PAGE_SOFT_DIRTY
> bit set get swapped out, the bit is getting lost and no longer
> available when pte read back.

Potentially silly question (due to my completely lack of understanding
of how swapping works in Linux): what about file-backed pages?
(Arguably these would be best supported by filesystems instead of by
the core vm, in which case it might make sense to drop soft-dirty
support for these pages entirely.)

--Andy
