Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaHVDf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 23:35:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:38892 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbaHVDfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 23:35:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,377,1406617200"; 
   d="scan'208";a="580217485"
Date: Fri, 22 Aug 2014 11:35:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes visible
 slowdown in ftrace switching
Message-ID: <20140822033529.GA7541@localhost>
References: <1383326384.6788.49.camel@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1383326384.6788.49.camel@pathway.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Petr,

Sorry for picking up this old thread, but I noticed your attached
ftrace test script and would like to ask for your permission to
include it in

        https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git

which is GPLv2. If you kindly agree, I'll run it actively for testing
the upstream linux kernels.

Thanks,
Fengguang

--6TrnltStXW4iwmi0
Content-Type: application/x-shellscript; name=test-ftrace
Content-Disposition: attachment; filename=test-ftrace

#!/bin/bash

echo "Testing ftrace - begin"

cd /sys/kernel/debug/tracing

count=0
while test $count -lt 100 ; do
    for tracer in function nop ; do
        echo $tracer >current_tracer
        echo 1 >tracing_on
        echo 0 >tracing_on
    done
    count=$(($count + 1))
done

cd -

echo "Testing ftrace - end"




--6TrnltStXW4iwmi0--
