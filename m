Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaIAGkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:40:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:9988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaIAGkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:40:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,440,1406617200"; 
   d="scan'208";a="566436313"
Message-ID: <540414AB.9000004@linux.intel.com>
Date: Mon, 01 Sep 2014 09:39:39 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, Ingo Molnar <mingo@kernel.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <53F6F14B.1030609@redhat.com> <20140822074224.GB7372@gmail.com> <53FFEEC0.4000304@redhat.com>
In-Reply-To: <53FFEEC0.4000304@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 29/08/2014 06:08, Jason Wang wrote:
> Yes, but rx busy polling only works in process context and does not
> disable bh, so it may be not an issue.

sk_busy_loop() uses rcu_read_lock_bh(), so it does run with bh disabled.

-Eliezer
