Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3CYKKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:10:09 -0400
Received: from mx2.digadd.de ([195.47.195.236]:41465 "EHLO mx1.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753081Ab3CYKKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:10:07 -0400
X-Greylist: delayed 1605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 06:10:07 EDT
Message-ID: <51501C0A.5060406@digadd.de>
Date: Mon, 25 Mar 2013 10:42:34 +0100
From: Christian Schmidt <schmidt@digadd.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130312 Thunderbird/17.0.4
MIME-Version: 1.0
To: dm-crypt@saout.de
CC: linux-kernel@vger.kernel.org
Subject: kworkers for dm-crypt locked to CPU core 0?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I am trying to troubleshoot some strange performance issues I am seeing
on a machine of mine. Said machine had 10 drives mapped via separate
dm-crypt instances. The aggregate (read) throughput seems to hover
around 120-130MB/s (looking at iostat -x -d) when running an instance of
dd if=/dev/dm-<instance> of=/dev/null bs=1m for each mapping. However
"top" shows that one core is loaded with 99% system tasks, and two to
three cores are spinning in iowait. All the kworkers get their share of
roughly 10% CPU.

"taskset" shows that all of the kworkers have an affinity mask of 1, so
they can run on core 0 only, and trying to change it results in an error
of "Invalid argument".

Is there a way I can make the scheduler put those on multiple cores?

Please cc: me since I am not subscribed.

Regards,
Christian
