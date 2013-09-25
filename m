Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3IYL0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:26:54 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45698 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3IYL0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:26:53 -0400
Date: Wed, 25 Sep 2013 13:26:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com
Subject: Re: [PATCH] perf: fix two warning in bench/numa
Message-ID: <20130925112629.GB29884@gmail.com>
References: <1379839764-9245-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20130925073515.GA7053@weiyang.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925073515.GA7053@weiyang.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wei Yang <weiyang@linux.vnet.ibm.com> wrote:

> Hi, all
> 
> Any comments on this one? 
> 
> These two warnings will break the compile of perf under 32-bit machine.

fix looks good to me.

> >-			if (diff.tv_sec >= g->p.nr_secs) {
> >+			if (diff.tv_sec >= (time_t)g->p.nr_secs) {

> >-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
> >+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016"PRIu64"]\n",

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
