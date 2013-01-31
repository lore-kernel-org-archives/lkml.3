Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3AaXHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:07:54 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:58285 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3AaXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:07:52 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301312306.r0VN6tBx012280@como.maths.usyd.edu.au>
Date: Fri, 1 Feb 2013 10:06:55 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301312306.r0VN6tBx012280@como.maths.usyd.edu.au>
To: 695182@bugs.debian.org, ben@decadent.org.uk
Subject: Re: Bug#695182: [RFC] Reproducible OOM with just a few sleeps
Cc: dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pavel@ucw.cz
In-Reply-To: <1359639529.31386.49.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ben,

> Based on your experience I might propose to change the automatic kernel
> selection for i386 so that we use 'amd64' on a system with >16GB RAM and
> a capable processor.

Don't you mean change to amd64 for >4GB (or any RAM), never using PAE?
PAE is broken for any amount of RAM. More precisely, PAE with any RAM
fails the "sleep test":
  n=0; while [ $n -lt 33000 ]; do sleep 600 & ((n=n+1)); done
and with >32GB fails the "write test":
  n=0; while [ $n -lt 99 ]; do dd bs=1M count=1024 if=/dev/zero of=x$n; ((n=n+1)); done
Why do you think 16GB is significant?

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
