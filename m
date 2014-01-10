Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaAJJgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:36:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54886 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaAJJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:36:52 -0500
Date: Fri, 10 Jan 2014 10:36:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf: clarify comment regarding event merging
Message-ID: <20140110093635.GI31570@twins.programming.kicks-ass.net>
References: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
 <1389311492-5059-3-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389311492-5059-3-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:51:31PM -0800, Cody P Schafer wrote:
> There are actually 2 things about software events that allow us to
> merge them: they never fail to schedule _and_ they have transaction
> handlers we can (and do, when they are added to !sw groups) ignore. Note
> both of these in the comment on adding sw events to !sw groups.

The latter is a direct consequence of the former. Since they can always
be scheduled, they don't need any schedulability testing, and therefore
the transaction stuff is useless.


