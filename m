Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaL2BfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:35:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:35463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaL2BfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:35:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="505076568"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Peter Hurley <peter@hurleysoftware.com>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "ionut.m.alexa@gmail.com" <ionut.m.alexa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Di" <di.zhang@intel.com>,
        "Sun, Zhonghua" <zhonghua.sun@intel.com>
Subject: RE: [PATCH] move exit_task_work() before exit_fs().
Thread-Topic: [PATCH] move exit_task_work() before exit_fs().
Thread-Index: AQHQITL3mdB5I21gqEyyZHrRUq+JSpylwB0Q//9/n4CAAIuMoA==
Date: Mon, 29 Dec 2014 01:32:37 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD0266FC73@SHSMSX103.ccr.corp.intel.com>
References: <1419579926-28512-1-git-send-email-xindong.ma@intel.com>
 <20141226173849.GA9460@redhat.com>
 <3917C05D9F83184EAA45CE249FF1B1DD0266FC53@SHSMSX103.ccr.corp.intel.com>
 <54A0A9D5.2010804@hurleysoftware.com>
In-Reply-To: <54A0A9D5.2010804@hurleysoftware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBT1ZR1B015691

> On 12/28/2014 07:58 PM, Ma, Xindong wrote:
> >>
> >> On 12/26, Leon Ma wrote:
> >>>
> >>> We encountered following panic. The scenario is the process is
> >>> exiting and executing its task work. When closing dev node, the
> >>> driver triggers a firmware reload according to device status.
> >>> Because task->fs is
> >> set to NULL in exit_fs(), panic happens.
> >>
> >> I think this should be fixed somewhere else...
> > Yes, for this panic, I also think driver is not perfect and need a fix. But
> kernel should not add the limitation like this...
> >>
> >>> Task work is a common interface, we should not limite the resource
> >>> the
> >> user will utilize.
> >>
> >> Exactly. And note that with this patch exit_mm()..disassociate_ctty()
> >> paths can't use task works.
> > I don't get this. Currently disassociate_ctty() is also called after exit_mm()
> and exit_task_work(). My patch didn't change this.
> 
> ??
> 
> 742-	if (group_dead)
> 743:		disassociate_ctty(1);
> 744-	exit_task_namespaces(tsk);
> 745-	exit_task_work(tsk);
> 746-	exit_thread();
Sorry, I was checking the old source code when applying this mail. I did a check on latest code, and did not find disassociate_ctty() was using task work. So why this matters?
> 
> >> Not to mention that this patch moves exit_files() up, even before
> >> exit_mm(), without any explanation.
> > Moving exit_files() up is because exit_files() closes files and add tasks to
> task works.
> >>
> >> Add Al. May be we can move exit_fs() down after exit_task_work(), I
> >> dunno, but to me it would be better to change the driver.
> >>
> > I'm OK with this suggestion to fix this issue. I'm not sure whether in the
> future task work users will access other resources and expose other issues.
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
