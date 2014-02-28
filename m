Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaB1MEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:04:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33945 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaB1MEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:04:24 -0500
From: Matthew Leach <matthew.leach@arm.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Peter Ziljstra <peterz@infradead.org>
Subject: A question regarding TG load tracking functions in fair.c
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 28 Feb 2014 12:04:19 +0000
Message-ID: <87d2i7mojg.fsf@e106496-lin.cambridge.arm.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Feb 2014 12:04:20.0602 (UTC) FILETIME=[3671D5A0:01CF347D]
X-MC-Unique: 114022812042211001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I have a question regarding two lines of code in the functions
__update_cfs_rq_tg_load_contrib and __update_tg_runnable_avg. AFAICS
these functions update a load-tracking signal for the local RQ and an
aggregated signal in the TG for all RQs that belong to this TG. The
update is surrounded by conditions:

  if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {

for __update_tg_runnable_avg and

  if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {

for __update_cfs_rq_tg_load_contrib. Is this an optimisation to prevent
the signals being updated for small variations? Also, could you please
shed some light on the specific numbers used?

Thanks,
-- 
Matt

