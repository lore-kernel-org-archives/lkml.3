Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3LLAhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:37:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3LLAhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:37:53 -0500
Date: Wed, 11 Dec 2013 19:37:48 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] powernow-k6: fixes for the frequency driver
Message-ID: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here I'm sending three patches for k6 frequency governor.

1. the processor doesn't respond to cache snoops when changing the 
frequency, so we need to disable cache while doing the change.

2. it is impossible to read the default multiplier. After reset, the 
register always reports zero regardless of the current multiplier. So we 
set the multiplier based on current frequency and allow the user to 
override it with module parameter.

3. reorder frequencies from the highest to the lowest.

Mikulas
