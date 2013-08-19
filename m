Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab3HSVIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:08:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3HSVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:08:18 -0400
Date: Mon, 19 Aug 2013 14:08:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: Track vma changes with VM_SOFTDIRTY bit
Message-Id: <20130819140816.6c35952c0bc19c480a9664d6@linux-foundation.org>
In-Reply-To: <20130819195836.GO23919@moon>
References: <20130819195836.GO23919@moon>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 23:58:36 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Pavel reported that in case if vma area get unmapped and
> then mapped (or expanded) in-place, the soft dirty tracker
> won't be able to recognize this situation since it works on
> pte level and ptes are get zapped on unmap, loosing soft
> dirty bit of course.
> 
> So to resolve this situation we need to track actions
> on vma level, there VM_SOFTDIRTY flag comes in. When
> new vma area created (or old expanded) we set this bit,
> and keep it here until application calls for clearing
> soft dirty bit.
> 
> Thus when user space application track memory changes
> now it can detect if vma area is renewed.

Can we please update Documentation/vm/soft-dirty.txt for this?
