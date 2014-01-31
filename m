Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaAaDqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 22:46:17 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:43085 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaAaDqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 22:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <1391134615.28432.83.camel@edumazet-glaptop2.roam.corp.google.com>
References: <alpine.DEB.2.10.1401180036020.18419@dinf>
	<1390062576.31367.519.camel@edumazet-glaptop2.roam.corp.google.com>
	<alpine.DEB.2.02.1401181101220.579@dtop>
	<alpine.DEB.2.02.1401292301070.5905@dtop>
	<1391134615.28432.83.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Thu, 30 Jan 2014 19:46:15 -0800
Message-ID: <CAADnVQ+vCikFY-te2U8wD+ustNW-o6Cqs8ye5ZfyNcU6vPQzNA@mail.gmail.com>
Subject: Re: kmem_cache_alloc panic in 3.10+
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: dormando <dormando@rydia.net>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 6:16 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2014-01-29 at 23:05 -0800, dormando wrote:
>
>> We hit the routing code fairly hard. Any hints for what to look at or how
>> to instrument it? Or if it's fixed already? It's a real pain to iterate
>> since it takes ~30 days to crash, usually. Sometimes.

sounds like adding mdelay() didn't help to crash it sooner. Then I don't
see how my dst fix was causing it to crash more often. Something odd.
fyi just to check it more thoroughly I've been running with mdelay()
and config_slub_debug_on for a week without issues.

> I really wonder... it looks like a possible in SLUB. (might be already
> fixed)
>
> Could you try using SLAB instead ?

try config_slub_debug_on=y ? it should catch double free and other things.
