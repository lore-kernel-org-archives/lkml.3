Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3B0XM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:12:58 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40468 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3B0XM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:12:57 -0500
Date: Wed, 27 Feb 2013 15:12:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] staging: android: lowmemorykiller: Add config option
 to support oom_adj values
In-Reply-To: <CAMP5XgcjdZk5MZ9v+W5phgWgE4Q0Pc_2FfopapjctsV6sdguLQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302271509230.24485@chino.kir.corp.google.com>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org> <1361945258-24420-2-git-send-email-john.stultz@linaro.org> <alpine.DEB.2.02.1302271417000.7155@chino.kir.corp.google.com>
 <CAMP5XgcjdZk5MZ9v+W5phgWgE4Q0Pc_2FfopapjctsV6sdguLQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-456797978-1362006776=:24485"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-456797978-1362006776=:24485
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 27 Feb 2013, Arve Hjønnevåg wrote:

> > Umm, writes to /proc/pid/oom_adj already are converted to the
> > /proc/pid/oom_score_adj scale linearly.  Heavy NACK to this patch since
> > oom_adj is completely deprecated.
> 
> I know it is deprecated, but your change, staging: android,
> lowmemorykiller: convert to use oom_score_adj, broke existing
> user-space code that still write to /proc/pid/oom_adj. This option
> lets you build a kernel that supports our user-space code until that
> user-space has been converted to use /proc/pid/oom_score_adj.
> 

As stated, writes to /proc/pid/oom_adj already are converted to a linear 
scale and stored in /proc/pid/oom_score_adj.  This is done with

	oom_adj == 15	->	oom_score_adj = 1000
	oom_adj != 15	->	oom_score_adj = (oom_adj * -1000) / -17

since the maximum oom_score_adj is 1000 and the minimum oom_adj is -17.

How does this not work as needed?
--531381512-456797978-1362006776=:24485--
