Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925AbaFSUSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:18:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:63718 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbaFSUSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:18:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="560357933"
Date: Thu, 19 Jun 2014 13:18:01 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140619201801.GV8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
 <20140619180028.GU8178@tassilo.jf.intel.com>
 <CABPqkBTw9wi1LSoqWUYcN2W1fvBYDfsdqkdxDTPQ0rWUEUFLmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTw9wi1LSoqWUYcN2W1fvBYDfsdqkdxDTPQ0rWUEUFLmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't quite understand that.
> You need to know which events support PEBS. You need a table

We're talking about the kernel allowing things here.
Yes the user still needs to know what supports PEBS, but 
that doesn't concern the kernel.

You can just allow it for all, it's a nop if the event doesn't
support it. And also the fields like DataLA are simply 0 when 
not supported.

The only thing you need is a rule to limit to 4 counters.

Then only cases that are special (PREC_DIST, extra registers) 
would need to be handled explicitely.

-Andi
