Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3B1Bll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:41:41 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43959 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3B1Blj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:41:39 -0500
Date: Wed, 27 Feb 2013 17:41:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] staging: android: lowmemorykiller: Add config option
 to support oom_adj values
In-Reply-To: <CAMP5XgdE-Ui9qiLGjvAXk13LbCzn-bHEC_AsxQ8dWpz+R-qSDg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302271739520.1648@chino.kir.corp.google.com>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org> <1361945258-24420-2-git-send-email-john.stultz@linaro.org> <alpine.DEB.2.02.1302271417000.7155@chino.kir.corp.google.com> <CAMP5XgcjdZk5MZ9v+W5phgWgE4Q0Pc_2FfopapjctsV6sdguLQ@mail.gmail.com>
 <alpine.DEB.2.02.1302271509230.24485@chino.kir.corp.google.com> <CAMP5XgemB4AdKEY4HFLwupo1CGv89hbmB+HUYYN8qdQRYCTdHg@mail.gmail.com> <alpine.DEB.2.02.1302271613210.27317@chino.kir.corp.google.com>
 <CAMP5XgdE-Ui9qiLGjvAXk13LbCzn-bHEC_AsxQ8dWpz+R-qSDg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1438450809-1362015698=:1648"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1438450809-1362015698=:1648
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 27 Feb 2013, Arve Hjønnevåg wrote:

> > Explain how this can possibly be consistent if your system includes two
> > processes, one writing oom_adj values and one writing oom_score_adj
> > values, and the kernel has this new option enabled?
> 
> These values are all written by the same process. If you want to
> improve this, the lowmemorykiller will need a separate score_adj
> parameter so that it knows for sure which type of value it receives.
> You changed the meaning of /sys/module/lowmemorykiller/parameters/adj.
> This patch restores the old behavior as long as the values you write
> are within the range oom_adj, while still supporting the new behavior
> you added in the likely case that one of the values are out of range
> for oom_adj.
> 

Then remove the config option entirely and add a new score_adj file that 
gets mapped from writes to adj.  No reason to tie the kernel config to a 
particular userspace implementation (even though it's been like this for 
over a year).  Nack to this patch.
--531381512-1438450809-1362015698=:1648--
