Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3FZQN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:13:29 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57416 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3FZQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:13:28 -0400
Message-ID: <51CB1323.6090305@gmail.com>
Date: Wed, 26 Jun 2013 10:13:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>,
        Dave Chiluk <chiluk@canonical.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Scheduler accounting inflated for io bound processes.
References: <51C35C05.1070005@canonical.com> <1372176104.7497.86.camel@marge.simpson.net> <1372182534.7497.129.camel@marge.simpson.net> <20130626093713.GA27385@gmail.com> <20130626104243.GE28407@twins.programming.kicks-ass.net> <20130626155048.GA7399@gmail.com> <51CB110E.6010707@gmail.com> <20130626161051.GA8207@gmail.com>
In-Reply-To: <20130626161051.GA8207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/13 10:10 AM, Ingo Molnar wrote:
>> Sampled H/W events have an adaptive period that converges to the desired
>> sampling rate. The first few samples come in 10 usecs are so apart and
>> the time period expands to the desired rate. As I recall that adaptive
>> algorithm starts over every time the event is scheduled in.
>
> Yes, but last I checked it (2 years ago? :-) the auto-freq code was
> converging pretty well to the time clock, with little jitter - in essence
> turning it into a fixed-period, fixed-frequency sampling method. That
> would explain Mike's results.

It does converge quickly and stay there for CPU-based events. My point 
was more along the lines that the code is there. Perhaps a tweak to add 
jitter to the period would address fixed period sampling affects.

David
