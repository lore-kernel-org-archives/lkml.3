Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3LZCaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 21:30:16 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:45454 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LZCaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 21:30:14 -0500
Date: Wed, 25 Dec 2013 20:30:09 -0600
From: Rob Landley <rob@landley.net>
Subject: Question about /proc/uptime
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
X-Mailer: Balsa 2.4.11
Message-Id: <1388025009.1176.17@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two values here, the first is seconds since boot time (which  
is just elapsed time; at one point it was ajusted for suspend and that  
was revered as confusing).

The second value isn't documented but looking at fs/proc/uptime.c I  
think it's idle time? Except, if yo uadd up the idle time from all  
processors wouldn't you get 4x the uptime on a 4-way SMP system that's  
been idle since boot?

Also, is this actual "cpu was on but not doing anything" time, so  
doesn't count suspend as idle? So if you subtract idle from uptime (on  
a uniprocessor system) on a system that spent some of its time  
suspended, what do you get? Amount of time the system "wasn't idle"  
means... Is suspend time idle or not idle?

Confused,

Rob