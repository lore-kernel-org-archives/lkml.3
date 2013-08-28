Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3H1Tec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:34:32 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:58369 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532Ab3H1Te2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:34:28 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 15:34:28 EDT
Date: Wed, 28 Aug 2013 19:28:02 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 1/2] mm: make vmstat_update periodic run conditional
In-Reply-To: <CAOtvUMdPswm3pHesXAzLYA4c7yzsXKoRoOt2T3LWBCjZ86ybpg@mail.gmail.com>
Message-ID: <00000140c6659902-f76c4733-ff61-47d9-b0d2-69fd04253aa3-000000@email.amazonses.com>
References: <CAOtvUMc5w3zNe8ed6qX0OOM__3F_hOTqvFa1AkdXF0PHvzGZqg@mail.gmail.com> <1371672168-9869-1-git-send-email-gilad@benyossef.com> <0000013f61e7609b-a8d1907b-8169-4f77-ab83-a624a8d0ab4a-000000@email.amazonses.com> <CAOtvUMe=QQni4Ouu=P_vh8QSb4ZdnaX_fW1twn3QFcOjYgJBGA@mail.gmail.com>
 <000001405e70a92f-3b2a0b89-f807-45d7-af70-9e7292156dd4-000000@email.amazonses.com> <CAOtvUMdPswm3pHesXAzLYA4c7yzsXKoRoOt2T3LWBCjZ86ybpg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.28-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Gilad Ben-Yossef wrote:

> If the code does not consider setting the vmstat_cpus bit in the mask
> unless we are running
> on a CPU in tickless state, than we will (almost) never set
> vmstat_cpus since we will (almost)
> never be tickless in a deferrable work -

Sorry never got around to answering this one. Not sure what to do about
it.

How about this: Disable the vmstats when there is no diff to handle
instead?  This means that the OS was quiet during the earlier period. That
way you have an independent criteria for switching vmstat work off from
tickless. Would even work when there are multiple processes running on the
processor if none of them causes counter updates.

In the meantime there are additional patches for the vmstat function
pending for merge from me (not related to the conditional running of
vmstat but may make it easier to implement). So if you want to do any work
then please on top of the newer release available from Andrew's tree.

