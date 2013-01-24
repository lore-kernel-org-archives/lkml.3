Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3AXRF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:05:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3AXRF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:05:56 -0500
Message-ID: <510169EA.3070506@redhat.com>
Date: Thu, 24 Jan 2013 09:05:46 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Anton Arapov <anton@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: pre-filtering
References: <20130113185916.GA25831@redhat.com> <20130124121720.GA3104@gmail.com> <20130124154018.GA8580@redhat.com>
In-Reply-To: <20130124154018.GA8580@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 07:40 AM, Oleg Nesterov wrote:
> I'll try to implement the pid-base filtering at least for
> tracing/uprobe_events, but this needs a time. Not only I am not familiar
> with this code, I am not sure how this interface should actually look.
> And I agree, perf should be able to use it somehow, perhaps at least
> to allow to probe a single task/mm.

Even without changing perf's interface, it already has constraints for
its child processes (versus --all-cpus) or for specific pid/tid/uid.
Pre-filtering could help enforce and optimize those constraints.
