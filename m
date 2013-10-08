Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3JHK51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:57:27 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61917 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3JHK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:57:24 -0400
Message-ID: <5253E50C.1060608@gmail.com>
Date: Tue, 08 Oct 2013 19:57:16 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: david@fromorbit.com
CC: mpatocka@redhat.com, thornber@redhat.com, devel@driverdev.osuosl.org,
        snitzer@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com,
        joe@perches.com, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ejt@redhat.com, cesarb@cesarb.net, m.chehab@samsung.com,
        ruby.wktk@gmail.com
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
References: <20130916215357.GA5015@redhat.com> <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com> <20130926034325.GO26872@dastard> <20131001082654.GA10326@debian> <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com> <20131004020417.GF4446@dastard> <524FC4F4.6050401@gmail.com> <20131007234307.GP4446@dastard>
In-Reply-To: <20131007234307.GP4446@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

> i.e. there's no point justifying a behaviour with "we could do this
> in future so lets ignore the impact on current users"...
Sure, I am happy if we find a solution that
is good for both of us or filesystem and block in other word.

> e.g. what happens if a user has a mixed workload - one where
> performance benefits are only seen by delaying FUA, and another that
> is seriously slowed down by delaying FUA requests?  This is where
> knobs are problematic....
You are right.
But there is no perfect solution to satisfy all.
Dealing with each requirement will only complicate the code.
Stepping away from the user and
focusing on filesystem-block boundary
>> Maybe, writeboost should disable deferring barriers
>> if barrier_deadline_ms parameter is especially 0.
adding the switch for the mounted filesystem to decides on/off
is a simple but effective solution I believe.

Deciding per bio basis instead of per device could be an another solution.
I am happy if I can check the bio if it "may or may not defer the barrier". 

Akira
