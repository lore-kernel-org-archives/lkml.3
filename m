Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab3GXTTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:19:00 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:59435 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3GXTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:18:58 -0400
Date: Wed, 24 Jul 2013 23:18:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130724191856.GA27992@moon>
References: <20130724163734.GE24851@moon>
 <CALCETrVWgSMrM2ujpO092ZLQa3pWEQM4vdmHhCVUohUUcoR8AQ@mail.gmail.com>
 <20130724171728.GH8508@moon>
 <1374687373.7382.22.camel@dabdike>
 <CALCETrV5MD1qCQsyz4=t+QW1BJuTBYainewzDfEaXW12S91K=A@mail.gmail.com>
 <20130724181516.GI8508@moon>
 <CALCETrV5NojErxWOc2RpuYKE0g8FfOmKB31oDz46CRu27hmDBA@mail.gmail.com>
 <20130724185256.GA24365@moon>
 <51F0232D.6060306@parallels.com>
 <20130724190453.GJ8508@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724190453.GJ8508@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:04:53PM +0400, Cyrill Gorcunov wrote:
> On Wed, Jul 24, 2013 at 10:55:41PM +0400, Pavel Emelyanov wrote:
> > > 
> > > Well, some part of information already lays in pte (such as 'file' bit,
> > > swap entries) so it looks natural i think to work on this level. but
> > > letme think if use page struct for that be more convenient...
> > 
> > It hardly will be. Consider we have a page shared between two tasks,
> > then first one "touches" it and soft-dirty is put onto his PTE and,
> > subsequently, the page itself. The we go and clear sofr-dirty for the
> > 2nd task. What should we do with the soft-dirty bit on the page?
> 
> Indeed, this won't help. Well then, bippidy-boppidy-boo, our
> pants are metaphorically on fire (c)

(i meant page flags wont help)
