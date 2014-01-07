Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaAGQUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:20:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45601 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaAGQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:55 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, morten.rasmussen@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [11/11] system 1: Saving energy using DVFS
Date: Tue,  7 Jan 2014 16:19:47 +0000
Message-Id: <1389111587-5923-12-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 07 Jan 2014 16:19:52.0627 (UTC) FILETIME=[4B903030:01CF0BC4]
X-MC-Unique: 114010716195309101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s07GKS5h019856

Most modern systems use DVFS to save power by slowing down computation
throughput when less performance is necessary. The power/performance
relation is platform specific. Some platforms may have better energy
savings (energy per instruction) than others at low frequencies.

To have something to relate to, here is an anonymized example based on
a modern ARM platform:

Performance	Energy/instruction
1.0		1.0
1.3		1.6
1.7		1.8
2.0		1.9
2.3		2.1
2.7		2.4
3.0		2.7

Performance is frequency (~instruction issue rate) and
energy/instruction is the energy cost of executing one (or a fixed
number of instructions) at that level of performance (frequency). For
this example, it costs 2.7x more energy per instruction to increase the
performance from 1.0 to 3.0 (3x). That is, the amount of work
(instructions) that can be done on one battery charge is reduced by 2.7x
(~63%) if you run as fast as possible (3.0) compared to running at
slowest frequency (1.0).

A lot of things haven't been accounted for in this simplified example.
There is a number of factors that influence the energy efficiency
including whether the cpu is the only one awake in its frequency/power
domain or not. The numbers shown above won't be accurate for all
workloads. They are meant as a ballpark figures.

To save energy, the higher frequencies should be avoided and only used
when the application performance requirements can not be satisfied
otherwise (e.g. spread tasks across more cpus if possible).

When considering the total system power it may save energy in some
scenarios by running the cpu faster to allow other power hungry parts of
the system to be shut down faster. However, this is highly platform and
application dependent.

