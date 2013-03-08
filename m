Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab3CHHLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:11:33 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39165 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3CHHLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130308062827.GJ14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-10-git-send-email-yinghai@kernel.org>
	<20130308062827.GJ14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 23:11:31 -0800
X-Google-Sender-Auth: iPPV1us30nA4QjwU2zaNX7yyTBM
Message-ID: <CAE9FiQVYiLykLKA4gt3WKigkP+b_JwWy8kcK76wMAtFvSTv8kQ@mail.gmail.com>
Subject: Re: [PATCH 09/14] x86, mm, numa: set memblock nid later
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 10:28 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 07, 2013 at 08:58:35PM -0800, Yinghai Lu wrote:
>> Only set memblock nid one time.
>
> Would be awesome if the description explains why we're doing this and
> why we're allowed to do this now.

will add more:


set memblock nid will cause membock layout change like array could be doubled.
and we do not have current memblock limit set, so will put down under
1M and could
use too much under 1M.
And for fallback path, we can avoid restore memblock and remerge action.


After We use numa_meminfo nid for checking, we don't need to send it again.


Thanks

Yinghai
