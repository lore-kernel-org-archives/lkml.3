Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaGOObe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:31:34 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62023 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaGOObc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:31:32 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 15 Jul 2014 10:36:33 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: perf: FORMAT_GROUP on attached process stops working in 3.16-rc
Message-ID: <alpine.DEB.2.11.1407151030550.20353@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I noticed in the 3.16-rc kernels that one of my regression tests was 
failing, specifically
	https://github.com/deater/perf_event_tests/blob/master/tests/bugs/read_group_attached.c

This test creates an event group with two events and PERF_FORMAT_GROUP
set.

It creates a child process, stops it, attaches the event group to it, 
starts the events and the child, waits for the child to finish, stops the
events, then reads the value.

In theory a subsequent read from the group leader should return values for 
*both* events (due to PERF_FORMAT_GROUP) but this stopped working, it only 
returns the value for the leader.

I've bisected it down to change: 15a2d4de0eab5 
	"perf: Always destroy groups on exit"

So is this expected behavior due to this patch, or is it a regression?

Thanks,

Vince
