Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3KAO2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab3KAO2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:28:05 -0400
Message-ID: <5273BA58.6010404@redhat.com>
Date: Fri, 01 Nov 2013 10:27:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mel Gorman <mgorman@suse.de>, mingo@kernel.org, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
References: <20131031163144.0fd27457@annuminas.surriel.com> <20131101110825.GX2400@suse.de> <52739244.3060209@redhat.com> <20131101134424.GA32685@suse.de> <20131101142404.GG19466@laptop.lan>
In-Reply-To: <20131101142404.GG19466@laptop.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 10:24 AM, Peter Zijlstra wrote:
> On Fri, Nov 01, 2013 at 01:44:24PM +0000, Mel Gorman wrote:
>> Ok, I see your point now but still wonder if this is too specialised
>> for what we are trying to do.  Could it have been done with a read-write
>> semaphore with the global stop_cpus taking it for write and stop_two_cpus
>> taking it for read?
> 
> rwsem for read is still global state.. That said it should be fairly
> easy to use lglock for this.

I'll rewrite the patch using lglocks, that should make things
more readable.

-- 
All rights reversed
