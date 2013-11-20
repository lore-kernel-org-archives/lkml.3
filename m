Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3KTQeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:34:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3KTQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:32:58 -0500
Message-Id: <20131120160450.072555619@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 20 Nov 2013 17:04:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 0/7] Cure some vaux idle wrackage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran head-first into intel_powerclamp and acpi_pad yesterday -- afaict they
try and do pretty much the same thing but both had competing sets of bugs and
issues.

Related to that I went over the tree looking for preempt_enable_no_resched()
abuse.

I know that patch 3 isn't going to be popular with Arjan but you guys are going
to have to make that work. That stuff is hideously terrible.

A note to Zhang Rui, _never_ merge EXPORTs in another maintainers' guts without
an explicit ACK from him, Thomas was quite horrified when I asked him how
tick_nohz_idle_{enter,exit} got exported.

That said, thanks for a 'fun' two days :-(

