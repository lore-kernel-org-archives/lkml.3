Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaL2Bdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:33:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:35288 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbaL2Bdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:33:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,658,1413270000"; 
   d="scan'208";a="643873453"
From: "Ma, Xindong" <xindong.ma@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oleg@redhat.com" <oleg@redhat.com>, "mhocko@suse.cz" <mhocko@suse.cz>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "ionut.m.alexa@gmail.com" <ionut.m.alexa@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Di" <di.zhang@intel.com>,
        "Sun, Zhonghua" <zhonghua.sun@intel.com>
Subject: RE: [PATCH] move exit_task_work() before exit_fs().
Thread-Topic: [PATCH] move exit_task_work() before exit_fs().
Thread-Index: AQHQIUJnmdB5I21gqEyyZHrRUq+JSpylzCiw
Date: Mon, 29 Dec 2014 01:33:37 +0000
Message-ID: <3917C05D9F83184EAA45CE249FF1B1DD0266FC80@SHSMSX103.ccr.corp.intel.com>
References: <y> <1419579926-28512-1-git-send-email-xindong.ma@intel.com>
 <20141226193028.GE22149@ZenIV.linux.org.uk>
In-Reply-To: <20141226193028.GE22149@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Dec 26, 2014 at 03:45:25PM +0800, Leon Ma wrote:
> > We encountered following panic. The scenario is the process is exiting
> > and executing its task work. When closing dev node, the driver
> > triggers a firmware reload according to device status. Because task->fs is
> set to NULL in exit_fs(), panic happens.
> > Task work is a common interface, we should not limite the resource the
> user will utilize.
> 
> Fix your driver.  Forget ->fs being NULL; what will happen if your process is
> chrooted?
Thanks, But I'm not clear what is the limitation added to chroot env?
