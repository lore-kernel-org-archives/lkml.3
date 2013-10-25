Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3JYIni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:43:38 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:55649 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3JYIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
	<1814253454.3449.1382689853825.JavaMail.mail@webmail07>
Date: Fri, 25 Oct 2013 09:43:36 +0100
X-Google-Sender-Auth: hf4643Yk54gwMwzkFtnmMGOjVVc
Message-ID: <CA+55aFxhJUrqdvw1To=9KLdxhYAOVwZLLeJT5yMRY5BT1weuHA@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 9:30 AM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
>
> My feeling is that vm.dirty_ratio/vm.dirty_background_ratio should _not_ be
> percentage based, 'cause for PCs/servers with a lot of memory (say 64GB or
> more) this value becomes unrealistic (13GB) and I've already had some
> unpleasant effects due to it.

Right. The percentage notion really goes back to the days when we
typically had 8-64 *megabytes* of memory So if you had a 8MB machine
you wouldn't want to have more than one megabyte of dirty data, but if
you were "Mr Moneybags" and could afford 64MB, you might want to have
up to 8MB dirty!!

Things have changed.

So I would suggest we change the defaults. Or pwehaps make the rule be
that "the ratio numbers are 'ratio of memory up to 1GB'", to make the
semantics similar across 32-bit HIGHMEM machines and 64-bit machines.

The modern way of expressing the dirty limits are to give the actual
absolute byte amounts, but we default to the legacy ratio mode..

                Linus
