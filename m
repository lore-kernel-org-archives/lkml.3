Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3CLAaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:30:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51780 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754446Ab3CLA37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:29:59 -0400
Message-ID: <1363048198.3724.15.camel@joe-AO722>
Subject: Re: [PATCH v2 3/3] drivers: android: binder: Remove excessive
 indentation
From: Joe Perches <joe@perches.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Mirsal Ennaime <mirsal@mirsal.fr>, Greg Kroah-Hartman <greg@kroah.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 11 Mar 2013 17:29:58 -0700
In-Reply-To: <CAMP5XgfwCQDnRvog1tWixo=-mTb4tTZCy33h+Y__H7cW_N_M7g@mail.gmail.com>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-4-git-send-email-mirsal@mirsal.fr>
	 <1363046657.3724.11.camel@joe-AO722>
	 <CAMP5XgfwCQDnRvog1tWixo=-mTb4tTZCy33h+Y__H7cW_N_M7g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 17:21 -0700, Arve Hjønnevåg wrote:
> On Mon, Mar 11, 2013 at 5:04 PM, Joe Perches <joe@perches.com> wrote:
> ...
> > I think it's odd to use pr_info in binder_debug.
> > Why not use KERN_DEBUG or pr_debug/dynamic_debugging?
> >
> > #define binder_debug(mask, x...) \
> >         do { \
> >                 if (binder_debug_mask & mask) \
> >                         pr_info(x); \
> >         } while (0)
> >
> >
> 
> This code predates the dynamic_debugging framework, but I also find it
> easier to use so I would be reluctant to convert it unless there is an
> easy way to match the current behavior. It is useful to turn a set of
> debug messages on by class and to have some classes on by default.

No doubt it's easier this way and there are many, many
macros like it sprinkled throughout the kernel sources.

The dynamic_debug framework currently has no mask/level
use than can turn on/off classes of messages.

Emitting at KERN_INFO instead of KERN_DEBUG though is odd.





