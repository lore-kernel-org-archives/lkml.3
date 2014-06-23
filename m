Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaFWOPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:15:06 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:56658 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837AbaFWOPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:15:04 -0400
X-Yandex-Uniq: e11e4595-6a91-4faf-b23b-ef3b97325e3b
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 23 Jun 2014 18:14:53 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, jolsa@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, yangds.fnst@cn.fujitsu.com,
        adrian.hunter@intel.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf kvm: move perf_kvm__mmap_read into session utils
Message-ID: <20140623141453.GC20225@stfomichev-desktop.yandex.net>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-7-git-send-email-stfomichev@yandex-team.ru>
 <20140620144427.GF31524@kernel.org>
 <53A8346A.80905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A8346A.80905@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stanislav: are you seeing out of order timestamp errors or just trying to
> reuse the live code from perf-kvm?
Yes, I need events ordering, otherwise I see:
1. pagefault event
2. comm and mmap events for the process above

Hence I have to print cryptic messages without any details.

As Arnaldo pointed out, I have to look at Jiri Olsa's 'ordered samples
queue' patches; I probably can use only the queue, without the perf session.
