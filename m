Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaIBDaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbaIBDaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:30:08 -0400
Message-ID: <54053998.4040604@redhat.com>
Date: Tue, 02 Sep 2014 11:29:28 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <53F6F14B.1030609@redhat.com> <20140822074224.GB7372@gmail.com> <53FFEEC0.4000304@redhat.com> <540414AB.9000004@linux.intel.com>
In-Reply-To: <540414AB.9000004@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 02:39 PM, Eliezer Tamir wrote:
> On 29/08/2014 06:08, Jason Wang wrote:
>> > Yes, but rx busy polling only works in process context and does not
>> > disable bh, so it may be not an issue.
> sk_busy_loop() uses rcu_read_lock_bh(), so it does run with bh disabled.
>
> -Eliezer

True, so we need probably also exit the loop when there are pending bhs.
