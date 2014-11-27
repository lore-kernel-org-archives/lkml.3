Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaK0AdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:33:03 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60816 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaK0AdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:33:01 -0500
MIME-Version: 1.0
In-Reply-To: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>
References: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 26 Nov 2014 16:33:00 -0800
X-Google-Sender-Auth: saCw9OtqZk4GbFfG9K9O7ShvbtA
Message-ID: <CA+55aFwjTTcGFbbEPWckxZHya5PFWo+MFbK9zMzoqZorXV21nQ@mail.gmail.com>
Subject: Re: [RFC v2 1/2] compiler: use compiler to detect integer overflows
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 3:58 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> We've used to detect integer overflows by causing an overflow and testing the
> result. For example, to test for addition overflow we would:

So I don't like this, for a very simple reason: it doesn't work for
older gcc versions.

Your "check_add_overflow()" doesn't actually do it. It just
perpetuates any bugs you find. For unsigned additions, it's pointless,
and for signed additions it remains as buggy as it was before.

Also, your commit message is still *very*wrong*. You can't claim that
integer addition overflow is undefined. It's undefined onyl for
_signed_ integer types, and that's a big big difference.

So no. This still doesn't work.

                     Linus
