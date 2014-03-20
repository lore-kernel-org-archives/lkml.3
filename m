Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaCTHHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:07:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:50668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaCTHHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:07:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,692,1389772800"; 
   d="scan'208";a="476203168"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Peng Tao <bergwolf@gmail.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Thread-Topic: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Thread-Index: AQHPQqvhmGRT/iVq/UyFTbqnXI+TbZrnTU6AgAAE6ACAAAPpAIAACxSAgAAbjICAAKeMgIAA/mUA///AHQCAAGeEAIAAVyGA
Date: Thu, 20 Mar 2014 07:06:48 +0000
Message-ID: <CF4FEF90.9AF19%andreas.dilger@intel.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
 <20140318133331.GA23193@laptop.programming.kicks-ass.net>
 <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com>
 <20140318140504.GD23193@laptop.programming.kicks-ass.net>
 <CA+a=Yy567xtU0Osz+9-hTCNrzB65vE=ErYWTq880N+uEwG2DHA@mail.gmail.com>
 <20140318162319.GB5669@redhat.com>
 <CA+a=Yy51Ex=UdsCRn8Ty_s4XR4xbOZ_YAf3tejb=JyTgQ_QzRA@mail.gmail.com>
 <20140319173330.GA11923@redhat.com>
 <CF4F4C6F.9A880%andreas.dilger@intel.com>
 <20140319195520.GF8557@laptop.programming.kicks-ass.net>
In-Reply-To: <20140319195520.GF8557@laptop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.132.228]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF0ECC44F163EA4288D6775AAB3DE2B9@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/03/19, 1:55 PM, "Peter Zijlstra" <peterz@infradead.org> wrote:

>On Wed, Mar 19, 2014 at 07:44:29PM +0000, Dilger, Andreas wrote:
>> The original reason for l_wait_event() not using TASK_UNINTERRUPTIBLE
>> is to avoid the load on the server continually being
>>"num_service_threads"
>> regardless of whether they are actually doing something or not.  We
>> added various cases for periodic wakeups and such afterward.
>
>Hmm, maybe we should finally do the TASK_IDLE thing;
>
>  https://lkml.org/lkml/2013/11/12/710

That looks pretty interesting, and appears to do what we need.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


