Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3FZGgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:36:52 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:53068 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3FZGgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130620210556.GA13479@amt.cnet>
References: <20130620210556.GA13479@amt.cnet>
Date: Wed, 26 Jun 2013 16:36:49 +1000
Message-ID: <CAPM=9tzqmQP3txwudBZ0qh-hv8vULnoOgMfwefE+cuePEFLEsg@mail.gmail.com>
Subject: Re: [PATCH] vgacon.c: add cond reschedule points in vgacon_do_font_op
From: Dave Airlie <airlied@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> can result in a soft lockup:
>
> BUG: soft lockup - CPU#41 stuck for 67s! [setfont:1505]
>  RIP: 0010:[<ffffffff812c48da>]
> [<ffffffff812c48da>] vgacon_do_font_op.clone.0+0x1ba/0x550
>
> This is due to the 8192 (cmapsz) IO operations taking longer than expected
> due to lock contention in QEMU.
>
> Add conditional resched points in between writes allowing other tasks to
> execute.

I've applied this to drm-next against my best judgement as it steers
me close to being the console maintainer.

Dave.
