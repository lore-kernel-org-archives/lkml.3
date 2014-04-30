Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbaD3VBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:01:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbaD3VA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:00:59 -0400
Date: Wed, 30 Apr 2014 14:00:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, sandeen@redhat.com,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, mpatlasov@parallels.com,
        Motohiro.Kosaki@us.fujitsu.com
Subject: Re: [PATCH v5] mm,writeback: fix divide by zero in
 pos_ratio_polynom
Message-Id: <20140430140057.7d2a6e984b2ec987182d2a4e@linux-foundation.org>
In-Reply-To: <20140430164255.7a753a8e@cuia.bos.redhat.com>
References: <20140429151910.53f740ef@annuminas.surriel.com>
	<5360C9E7.6010701@jp.fujitsu.com>
	<20140430093035.7e7226f2@annuminas.surriel.com>
	<20140430134826.GH4357@dhcp22.suse.cz>
	<20140430104114.4bdc588e@cuia.bos.redhat.com>
	<20140430120001.b4b95061ac7252a976b8a179@linux-foundation.org>
	<53614F3C.8020009@redhat.com>
	<20140430123526.bc6a229c1ea4addad1fb483d@linux-foundation.org>
	<20140430160218.442863e0@cuia.bos.redhat.com>
	<20140430131353.fa9f49604ea39425bc93c24a@linux-foundation.org>
	<20140430164255.7a753a8e@cuia.bos.redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 16:42:55 -0400 Rik van Riel <riel@redhat.com> wrote:

> On Wed, 30 Apr 2014 13:13:53 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > This was a consequence of 64->32 truncation and it can't happen any
> > more, can it?
> 
> Andrew, this is cleaner indeed :)

I'm starting to get worried about 32-bit wraparound in the patch
version number ;)

> Masayoshi-san, does the bug still happen with this version, or does
> this fix the problem?
> 

We could put something like

	if (WARN_ON_ONCE(setpoint == limit))
		setpoint--;

in there if we're not sure.  But it's better to be sure!


