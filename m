Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaEBHFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 03:05:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbaEBHFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 03:05:00 -0400
Message-ID: <53633B81.1080403@redhat.com>
Date: Fri, 02 May 2014 02:30:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
References: <20140502004237.79dd3de6@annuminas.surriel.com> <1399011219.5233.55.camel@marge.simpson.net>
In-Reply-To: <1399011219.5233.55.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 02:13 AM, Mike Galbraith wrote:
> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote:
> 
>> Whether or not this is the right thing to do remains to be seen,
>> but it does allow us to verify whether or not the wake_affine
>> strategy of always doing affine wakeups and only disabling them
>> in a specific circumstance is sound, or needs rethinking...
> 
> Yes, it needs rethinking.
> 
> I know why you want to try this, yes, select_idle_sibling() is very much
> a two faced little bitch.

My biggest problem with select_idle_sibling and wake_affine in
general is that it will override NUMA placement, even when
processes only wake each other up infrequently...

-- 
All rights reversed
