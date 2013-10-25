Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3JYJP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:15:26 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:32824 "EHLO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3JYJPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:15:25 -0400
Date: Fri, 25 Oct 2013 11:15:55 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131025091555.GA30895@kipc2.localdomain>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 131025, Linus Torvalds wrote:
> On Fri, Oct 25, 2013 at 9:30 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> >
> > My feeling is that vm.dirty_ratio/vm.dirty_background_ratio should _not_ be
> > percentage based, 'cause for PCs/servers with a lot of memory (say 64GB or
> > more) this value becomes unrealistic (13GB) and I've already had some
> > unpleasant effects due to it.
> 
> Right. The percentage notion really goes back to the days when we
> typically had 8-64 *megabytes* of memory So if you had a 8MB machine
> you wouldn't want to have more than one megabyte of dirty data, but if
> you were "Mr Moneybags" and could afford 64MB, you might want to have
> up to 8MB dirty!!
> 
> Things have changed.
> 
> So I would suggest we change the defaults. Or pwehaps make the rule be
> that "the ratio numbers are 'ratio of memory up to 1GB'", to make the
> semantics similar across 32-bit HIGHMEM machines and 64-bit machines.
> 
> The modern way of expressing the dirty limits are to give the actual
> absolute byte amounts, but we default to the legacy ratio mode..
> 
>                 Linus

Is it currently possible to somehow set above values per block device?

I want default behaviour for almost everything but  DVD drives in DVD+RW
packet writing mode may easily take several minutes in case of a sync.

Karl


