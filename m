Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaJTJ4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:56:22 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbaJTJ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:56:18 -0400
Message-ID: <5444DC3F.20601@nod.at>
Date: Mon, 20 Oct 2014 11:56:15 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [UM] Long loop in __getnsdayoftime() after resume
 from ram
References: <E1Xg9cr-0007LK-S6@www17.your-server.de>
In-Reply-To: <E1Xg9cr-0007LK-S6@www17.your-server.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.10.2014 um 11:51 schrieb Thomas Meyer:
>> Hmm, does this always happen?
> 
> Yes, my single core system seems to trigger this every time after resume from ram.

What is your host kernel?

>> At least on my notebook it did not happen. I've started an UML yesterday 
>> suspended it and after more than 12h it worked fine today. 
>>
>> BTW: Do you see the issue also then freezing UML using the freezer cgroup?
> 
> I'm not sure what do you mean by this. Do I need to enable some special configs for this in the host or uml kernel?

Create on the host side a new freezer cgroup, put UML into it and freeze/thaw it.
i.e. mkdir /sys/fs/cgroup/freezer/uml ; echo <pid of a shell> >  /sys/fs/cgroup/freezer/uml/tasks.
In the said shell run UML and then freeze it using echo FROZEN > /sys/fs/cgroup/freezer/uml/freezer.state.
Later thaw it: echo THAWED > /sys/fs/cgroup/freezer/uml/freezer.state

Thanks,
//richard
