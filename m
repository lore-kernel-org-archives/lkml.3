Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaCDCs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:48:59 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44667 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaCDCs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:48:58 -0500
From: Pradeep Sawlani <pradeep.sawlani@gmail.com>
To: Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        MEMORY MANAGEMENT <linux-mm@kvack.org>, Dave Hansen <dave@sr71.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suri Maddhula <surim@amazon.com>, Matt Wilson <msw@amazon.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Pradeep Sawlani <sawlani@amazon.com>
Subject: [PATCH RFC 0/1] ksm: check and skip page, if it is already scanned
Date: Mon,  3 Mar 2014 18:48:52 -0800
Message-Id: <1393901333-5569-1-git-send-email-pradeep.sawlani@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pradeep Sawlani <sawlani@amazon.com>

Patch uses two bits to detect if page is scanned, one bit for odd cycle
and other for even cycle. This adds one more bit in page flags and
overloads existing bit (PG_owner_priv_1).
Changes are based of 3.4.79 kernel, since I have used that for verification.
Detail discussion can be found at https://lkml.org/lkml/2014/2/13/624
Suggestion(s) are welcome for alternative solution in order to avoid one more
bit in page flags.

Pradeep Sawlani (1):
  ksm: check and skip page, if it is already scanned

 include/linux/page-flags.h |   11 +++++++++++
 mm/Kconfig                 |   10 ++++++++++
 mm/ksm.c                   |   33 +++++++++++++++++++++++++++++++--
 3 files changed, 52 insertions(+), 2 deletions(-)

-- 
1.7.9.5

