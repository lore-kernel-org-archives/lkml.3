Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3B1GC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:02:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57928 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3B1GC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:02:58 -0500
MIME-Version: 1.0
In-Reply-To: <1361475708-25991-10-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1361475708-25991-10-git-send-email-n-horiguchi@ah.jp.nec.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 28 Feb 2013 01:02:37 -0500
X-Google-Sender-Auth: w6bLqmpydUB5QzzcewFK9UdWVpI
Message-ID: <CAHGf_=qq=+F4HMEE6P_g_ou7dQ6odu=DaefDsURjq5Yhxz99-Q@mail.gmail.com>
Subject: Re: [PATCH 9/9] remove /proc/sys/vm/hugepages_treat_as_movable
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -        {
> -               .procname       = "hugepages_treat_as_movable",
> -               .data           = &hugepages_treat_as_movable,
> -               .maxlen         = sizeof(int),
> -               .mode           = 0644,
> -               .proc_handler   = hugetlb_treat_movable_handler,
> -       },

Sorry, no.

This is too aggressive remove. Imagine, a lot of shell script don't
have any error check.
I suggest to keep this file but change to nop (to output warning is better).
About 1-2 years after, we can remove this file safely.
