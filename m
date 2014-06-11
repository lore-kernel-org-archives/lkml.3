Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaFKJwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:52:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:34116 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFKJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:52:08 -0400
Message-ID: <1402480322.32126.13.camel@tkhai>
Subject: [PATCH 0/2] sched: Rework migrate_tasks() and check_for_tasks()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>
Date: Wed, 11 Jun 2014 13:52:02 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series fixes migration of throttled tasks and hierarchies
from dead cpu. Currently, they do not migrate at all, and they
may forever stay on dead cpu like in jail.

The first patch fixes migration, the second patch adds a little
set of cases, we should warn in dmesg.

---

Kirill Tkhai (2):
      sched: Rework migrate_tasks()
      sched: Rework check_for_tasks()


 kernel/cpu.c        |   33 ++++++++++++++--------
 kernel/sched/core.c |   75 ++++++++++++++-------------------------------------
 2 files changed, 40 insertions(+), 68 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>


