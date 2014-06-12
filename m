Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaFLBhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:37:55 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56481 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLBhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140611212540.GA16940@cloud>
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-5-git-send-email-bobby.prani@gmail.com> <20140611212540.GA16940@cloud>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 11 Jun 2014 21:37:22 -0400
Message-ID: <CAJhHMCC5dAvKZFmWnaDqS6zG+WeH-YT7qCTPypDEuEuYOGy_sw@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] kernel/rcu/tree.c:3435 fix a sparse warning
To: Josh Triplett <josh@joshtriplett.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 5:25 PM,  <josh@joshtriplett.org> wrote:
> On Wed, Jun 11, 2014 at 04:39:42PM -0400, Pranith Kumar wrote:
>> kernel/rcu/tree.c:3435:21: warning: incorrect type in argument 1 (different modifiers)
>> kernel/rcu/tree.c:3435:21:    expected int ( *threadfn )( ... )
>> kernel/rcu/tree.c:3435:21:    got int ( static [toplevel] [noreturn] *<noident> )( ... )
>>
>> by removing __noreturn attribute and adding unreachable() as suggested on the
>> mailing list: http://www.kernelhub.org/?p=2&msg=436683
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>
> No, we should not do this.  And the mailing list post you point to seems
> to explicitly recommend using noreturn rather than unreachable.
>
> If sparse doesn't understand this, that's a bug in sparse, not in the
> kernel.  Sparse needs to understand that it's OK to drop noreturn from a
> function pointer type, just not OK to add it.
>
> Rationale: If you call a noreturn function through a non-noreturn
> function pointer, you might end up with unnecessary cleanup code, but
> the call will work.  If you call a non-noreturn function through a
> noreturn function pointer, the caller will not expect a return, and may
> crash; *that* should require a cast.
>

Yes, I understand the rationale. I think this should be fixed in
sparse. Please drop this patch.

Thanks!
-- 
Pranith
