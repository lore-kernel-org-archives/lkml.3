Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238Ab3DGSAD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 14:00:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39019 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146Ab3DGSAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 14:00:02 -0400
MIME-Version: 1.0
Message-ID: <dc2642fc-f662-41cd-a236-fccf4c252dfa@default>
Date: Sun, 7 Apr 2013 10:59:18 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Bob Liu <bob.liu@oracle.com>,
        Ric Mason <ric.masonn@gmail.com>
Subject: RE: [PATCH part2 v6 0/3] staging: zcache: Support zero-filled pages
 more efficiently
References: <1364984183-9711-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130407090341.GA22589@hacker.(null)>
 <62e1fe34-e5be-42f5-83af-f8f428fce57b@default>
In-Reply-To: <62e1fe34-e5be-42f5-83af-f8f428fce57b@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dan Magenheimer
> Subject: RE: [PATCH part2 v6 0/3] staging: zcache: Support zero-filled pages more efficiently
> 
> > From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> > Subject: Re: [PATCH part2 v6 0/3] staging: zcache: Support zero-filled pages more efficiently
> >
> > Hi Dan,
> >
> > Some issues against Ramster:
> >
> 
> Sure!  I am concerned about Konrad's patches adding debug.c as they
> add many global variables.  They are only required when ZCACHE_DEBUG
> is enabled so they may be ok.  If not, adding ramster variables
> to debug.c may make the problem worse.

Oops, I just noticed/remembered that ramster uses BOTH debugfs and sysfs.
The sysfs variables are all currently required, i.e. for configuration
so should not be tied to debugfs or a DEBUG config option.  However,
if there is a more acceptable way to implement the function of
those sysfs variables, that would be fine.

Thanks,
Dan
