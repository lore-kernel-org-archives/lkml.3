Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaIPN0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:26:48 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaIPN0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:26:47 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC] Don'd hold work_sem while calling worker functions
Date: Tue, 16 Sep 2014 15:26:36 +0200
Message-Id: <1410873998-2955-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fail to see why we need work_sem while wrk->func() is executed.
Artem, do you have an idea?

Having the wear_leveling_worker() called without work_sem held
would simplify the fastmap code too. I'm currently reworking some
of it's code and I'm in locking hell. 8-)

Thanks,
//richard

[PATCH 1/2] UBI: Call worker functions without work_sem held
[PATCH 2/2] UBI: Get rid of __schedule_ubi_work()
