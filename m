Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3CURid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:38:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39940 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751186Ab3CURic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:38:32 -0400
Message-ID: <1363887512.30275.24.camel@joe-AO722>
Subject: Re: [PATCH 09/33] aio: dprintk() -> pr_debug()
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Date: Thu, 21 Mar 2013 10:38:32 -0700
In-Reply-To: <1363883754-27966-10-git-send-email-koverstreet@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
	 <1363883754-27966-10-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 09:35 -0700, Kent Overstreet wrote:
[]
> diff --git a/fs/aio.c b/fs/aio.c

Hi Kent.

I generally prefer pr_debug but maybe here's
a couple of things you don't already know.

> +#define pr_fmt(fmt) "%s: " fmt, __func__

dynamic debug can add __func__ to each output
with +f so I think this prefixing with %s, __func__
is unnecessary.

I do think
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
is fairly standard, (though that can be added by
dynamic_debug as well with -m)

For example, without dynamic debug enabled
but with DEBUG #defined and KBUILD_MODNAME
I could get in dmesg:
	aio: ENOMEM: nr_events too high
instead of
	ioctx_alloc: ENOMEM: nr_events too high
and I think that's more intelligible.

These messages are not emitted by default, only
when specifically enabled with dynamic_debug or
adding #define DEBUG to the sources or -DDEBUG
to the Makefile


