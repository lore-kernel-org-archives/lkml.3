Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaFFM1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:27:10 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:32960 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaFFM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140605133747.GB2942@dhcp22.suse.cz>
References: <53905594d284f_71f12992fc6a@nysa.notmuch>
	<20140605133747.GB2942@dhcp22.suse.cz>
Date: Fri, 6 Jun 2014 07:27:08 -0500
Message-ID: <CAMP44s2ExpR2OdvsiPVe9bdKdRYgsjEsXCfExTjQ_-eGMzvgKg@mail.gmail.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 8:37 AM, Michal Hocko <mhocko@suse.cz> wrote:

> We had a similar report for opensuse. The common part was that there was
> an IO to a slow USB device going on.

Actually I've managed to narrow down my synthetic test, and all I need
is to copy a big file, and it even happens reading and writing to the
SSD (although the stall is less severe).

Here's the test:
http://pastie.org/9264124

Just pass a big file as the first argument.

I don't have much memory in this machine, so I guess running out of
memory is the trigger.

-- 
Felipe Contreras
