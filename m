Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3LPRHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:07:16 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40139 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3LPRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:07:14 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] sctp: Consolidate and ratelimit deprecation warnings
Date: Mon, 16 Dec 2013 12:06:43 -0500
Message-Id: <1387213605-27206-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCTP protocol has several deprecation warnings in its setsockopt path that
can be triggered by unprivlidged users.  Since these are not ratelimited, we can
spam the logs quite easily here.  Since these are all deprecation warnings, and
that type of warning isn't uncommon in the rest of the kernel, lets make a
common pr_warn_deprecated macro to produce somewhat generalized ratelimited
deprecation warnings easily

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Vlad Yasevich <vyasevich@gmail.com>
CC: David Miller <davem@davemloft.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org


