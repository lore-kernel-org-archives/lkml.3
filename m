Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3GJLpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:45:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46855 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3GJLpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:45:04 -0400
Date: Wed, 10 Jul 2013 13:44:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old
 events
Message-ID: <20130710114408.GS25631@dyad.programming.kicks-ass.net>
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com>
 <20130708121557.GA17211@twins.programming.kicks-ass.net>
 <51DD4787.7080504@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DD4787.7080504@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 07:37:43PM +0800, Yan, Zheng wrote:
> On 07/08/2013 08:15 PM, Peter Zijlstra wrote:
> > On Thu, Jun 06, 2013 at 01:58:06PM +0800, Yan, Zheng wrote:
> >> From: "Yan, Zheng" <zheng.z.yan@intel.com>

> >>         before   overwrite mode      after   overwrite mode
> >> AVG      1000        999             1046        1044
> >> STDEV    19.4        19.5            17.1        17.9
> > 
> > OK, so I was sure I replied to this email; but apparently I didn't :/
> > 
> > So its still adding about 5% overhead to the regular case; this is sad.
> > 
> > What does something like the below do?
> > 
> 
> I re-test the patch on a different 32 core sandybridge-ep machine. the result is quite good.
> 
>        origin   origin overwrite       modified    modified overwrite
> AVG    1000      1044                   960        1006
> STDEV  39.0      26.0                   28.1       14.4

Nice! -- you did fix the snafu for the overwrite more before testing right?
