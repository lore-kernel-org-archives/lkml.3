Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3D0AHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 20:07:39 -0400
Received: from mx3.valvesoftware.com ([208.64.203.145]:38167 "EHLO
	mx3.valvesoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab3D0AHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 20:07:37 -0400
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 20:07:37 EDT
Message-ID: <517B1153.8000401@valvesoftware.com>
Date: Fri, 26 Apr 2013 16:44:19 -0700
From: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: <hannes@cmpxchg.org>
CC: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <riel@redhat.com>, <sonnyrao@chromium.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <akpm@linux-foundation.org>
Subject: IO regression after ab8fabd46f on x86 kernels with high memory
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: 86b76815-e903-4403-b95d-5abb05264373
X-Mlf-Version: 7.3.6.7163
X-Mlf-UniqueId: o201304262346350004768
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I initially observed this between kernels 3.2 and 3.5: on 3.2, copying a 
180M shared object on the same ext4 filesystem takes 0.6s. On 3.5, it 
takes between two and three minutes. It looks like a similar throughput 
regression happens on any machine running an i386 PAE kernel with high 
amounts of memory; the threshold seems to be 16G; passing mem=15G to the 
kernel commandline fixes it.

I bisected it to the following change:

commit ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d
Author: Johannes Weiner <jweiner@redhat.com>
Date:   Tue Jan 10 15:07:42 2012 -0800

     mm: exclude reserved pages from dirtyable memory

I realize running x86 kernels against high amounts of memory is not 
advised for various reasons, but I would assume that such a big 
regression in basic functionality to not be part of them. Is that 
accurate, or are these configurations expected to become unusable from 
3.3 onwards?

Also CCing Sonny since it looks like he tried to fix an overflow issue 
related to the same change with commit c8b74c2f66049, but I'm still 
experiencing the problem with a kernel built from master.

Thanks,
  - Pierre-Loup
