Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966083Ab3DRLRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:17:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46139
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792Ab3DRLRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:17:14 -0400
Message-ID: <1366283828.19383.7.camel@laptop>
Subject: Re: [tip:perf/urgent] perf: Treat attr.config as u64 in
 perf_swevent_init()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        tglx@linutronix.de, tt.rantala@gmail.com
Cc: linux-tip-commits@vger.kernel.org
Date: Thu, 18 Apr 2013 13:17:08 +0200
In-Reply-To: <tip-8176cced706b5e5d15887584150764894e94e02f@git.kernel.org>
References: <1365882554-30259-1-git-send-email-tt.rantala@gmail.com>
	 <tip-8176cced706b5e5d15887584150764894e94e02f@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 03:42 -0700, tip-bot for Tommi Rantala wrote:
> Commit-ID:  8176cced706b5e5d15887584150764894e94e02f
> Gitweb:     http://git.kernel.org/tip/8176cced706b5e5d15887584150764894e94e02f
> Author:     Tommi Rantala <tt.rantala@gmail.com>
> AuthorDate: Sat, 13 Apr 2013 22:49:14 +0300
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 15 Apr 2013 11:42:12 +0200
> 
> perf: Treat attr.config as u64 in perf_swevent_init()
> 
> Trinity discovered that we fail to check all 64 bits of
> attr.config passed by user space, resulting to out-of-bounds
> access of the perf_swevent_enabled array in
> sw_perf_event_destroy().

Gah, I so missed we could hide bits in the top word and then use them
in _destroy().

The alternative is of course to also truncate to int in _destroy(), but
yes keeping the natural size seems the best alternative.


