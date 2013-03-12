Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3CLAVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:21:30 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:46788 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3CLAV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <1363046657.3724.11.camel@joe-AO722>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
	<1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
	<1363044388-11409-4-git-send-email-mirsal@mirsal.fr>
	<1363046657.3724.11.camel@joe-AO722>
Date: Mon, 11 Mar 2013 17:21:28 -0700
Message-ID: <CAMP5XgfwCQDnRvog1tWixo=-mTb4tTZCy33h+Y__H7cW_N_M7g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: android: binder: Remove excessive indentation
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Joe Perches <joe@perches.com>
Cc: Mirsal Ennaime <mirsal@mirsal.fr>, Greg Kroah-Hartman <greg@kroah.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 5:04 PM, Joe Perches <joe@perches.com> wrote:
...
> I think it's odd to use pr_info in binder_debug.
> Why not use KERN_DEBUG or pr_debug/dynamic_debugging?
>
> #define binder_debug(mask, x...) \
>         do { \
>                 if (binder_debug_mask & mask) \
>                         pr_info(x); \
>         } while (0)
>
>

This code predates the dynamic_debugging framework, but I also find it
easier to use so I would be reluctant to convert it unless there is an
easy way to match the current behavior. It is useful to turn a set of
debug messages on by class and to have some classes on by default.

-- 
Arve Hjønnevåg
