Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab3HNXpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:45:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255Ab3HNXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:45:10 -0400
Date: Wed, 14 Aug 2013 16:45:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        dave@sr71.net, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] mm/hotplug: Verify hotplug memory range
Message-Id: <20130814164508.e62614c436df5eabfd504c8c@linux-foundation.org>
In-Reply-To: <1376523242.10300.403.camel@misato.fc.hp.com>
References: <1376162252-26074-1-git-send-email-toshi.kani@hp.com>
	<20130814150901.cd430738912a893d74769e1b@linux-foundation.org>
	<1376523242.10300.403.camel@misato.fc.hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 17:34:02 -0600 Toshi Kani <toshi.kani@hp.com> wrote:

> > Printing a u64 is problematic.  Here you assume that u64 is implemented
> > as unsigned long long.  But it can be implemented as unsigned long, by
> > architectures which use include/asm-generic/int-l64.h.  Such an
> > architecture will generate a compile warning here, but I can't
> > immediately find a Kconfig combination which will make that happen.
> 
> Oh, I see.  Should I add the casting below and resend it to you?
> 
>                 (unsigned long long)start, (unsigned long long)size);

I was going to leave it as-is and see if anyone else can find a way of
triggering the warning.  But other sites in mm/memory_hotplug.c have
the casts so I went ahead and fixed it.

