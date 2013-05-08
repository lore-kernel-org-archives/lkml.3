Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3EHVBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:01:50 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34761 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932091Ab3EHVBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:01:47 -0400
Message-Id: <20130508210102.898396979@asylum.americas.sgi.com>
User-Agent: quilt/0.47-15.17.1
Date: Wed, 08 May 2013 16:01:02 -0500
From: athorlton@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch 0/2] fix output from dump_stack/warn on multi-processor systems
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix up issues with interspersed output from multiple
simultaneous calls to warn or dump_stack on multi-cpu systems.

The first patch serializes the output from dump_stack.  The second 
adds the cpu/pid to the WARNING line, displayed by 
warn_slowpath_common so that it can be matched up with the 
appropriate stack trace.

