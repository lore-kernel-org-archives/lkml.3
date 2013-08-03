Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3HCS2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 14:28:12 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33199 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3HCS2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 14:28:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130801190514.GA3216@redhat.com>
References: <20130801190455.GA3194@redhat.com>
	<20130801190514.GA3216@redhat.com>
Date: Sat, 3 Aug 2013 11:28:10 -0700
X-Google-Sender-Auth: sRTZ-hs-6j-B-9gJo90VtN88rfA
Message-ID: <CAGXu5j+=-n7S1VNyFR8oZ+bzh3iG8_cirUaNa48CGGh7DX805Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] exec: kill "int depth" in search_binary_handler()
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Nobody except search_binary_handler() should touch ->recursion_depth,
> "int depth" buys nothing but complicates the code, kill it.

I'd like to see a comment added to binfmts.h's recursion_depth field
that reminds people that recursion_depth is for
search_binary_handler()'s use only, and a binfmt loader shouldn't
touch it. Besides that, yeah, sensible clean up.

-Kees

-- 
Kees Cook
Chrome OS Security
