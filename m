Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaAGQVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:21:50 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45352 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaAGQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:19:51 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, markgross@thegnar.org, vincent.guittot@linaro.org,
        catalin.marinas@arm.com, morten.rasmussen@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [3/11] issue 3: No understanding of potential cpu capacity
Date: Tue,  7 Jan 2014 16:19:39 +0000
Message-Id: <1389111587-5923-4-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
References: <1389111587-5923-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 07 Jan 2014 16:19:48.0111 (UTC) FILETIME=[48DF19F0:01CF0BC4]
X-MC-Unique: 114010716195013001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s07GLvTq019888

To minimize energy it may sometimes be better to put waking tasks on
partially loaded cpus instead of powering up more cpus (particularly if
it implies powering up a new cluster/group of cpus with associated
caches). To make that call, information about the potential spare cycles
on the busy cpus is required.

Currently, the CFS scheduler has no knowledge about frequency scaling.
Frequency scaling governors generally try to match the frequency to
the load, which means that the idle time has no absolute meaning. The
potential spare cpu capacity may be much higher than indicated by the
idle time if the cpu is running at a low P-state.

The energy trade-off may justify putting another task on a loaded cpu
even if it causes a change to a higher P-state to handle the extra load.
Related issues are frequency (and cpu micro architecture) invariant task
load and power topology information, which are both needed to enable the
scheduler for energy-aware task placement. This is covered in more
detail in issue 5.

The potential cpu capacity cannot be assumed to be constant as thermal
management may restrict the usage of high performance P-states
dynamically.


