Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3J3P1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:27:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab3J3P1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:27:50 -0400
Message-ID: <1383146865.11574.3.camel@deneb.redhat.com>
Subject: linux-next build failure
From: Mark Salter <msalter@redhat.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ccross@android.com
Date: Wed, 30 Oct 2013 11:27:45 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch causes a build failure for no-MMU builds:

  commit 41df2957cb010edfa2f9d394d3617da6beeeb660
  Author: Colin Cross <ccross@android.com>
  Date:   Wed Oct 30 11:45:39 2013 +1100

      mm: add a field to store names for private anonymous memory
    
The problem is:

  kernel/built-in.o: In function `sys_prctl':
  (.text+0x19854): undefined reference to `madvise_set_anon_name'

madvise doesn't make sense without an MMU.

--Mark


