Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3B1CO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 21:14:29 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56867 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab3B1CO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 21:14:28 -0500
Message-ID: <512EBD80.8070101@linaro.org>
Date: Wed, 27 Feb 2013 18:14:24 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
CC: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [RFD] Proposal for merging Android sync driver in staging
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to get a discussion going about submitting the Android sync 
driver to staging.

I know there is currently some very similar work going on with the 
dmabuf-fences, and rather then both approaches being worked out 
individually on their own, I suspect there could be better collaboration 
around this effort.

So my proposal is that we merge the Android sync driver into staging.

In my mind, this has the following benefits:
1) It allows other drivers that depend on the sync interface to also be 
submitted to staging, rather then forcing those drivers to be hidden 
away in various out of tree git repos, location unknown.

2) It would provide a baseline view to the upstream community of the 
interface Android is using, providing  a real-world, active use case of 
the functionality.

Once the sync driver is in staging, if the dmabuf-fences work is fully 
sufficient to replace the Android sync driver, we should be able to 
whittle down the sync driver until its just a interface shim (and at 
which point efforts can be made to convert Android userland over to 
dmabuf-fences).

However, if the dmabuf-fences work is not fully sufficient to replace 
the android sync driver, we should be able to at least to whittle down 
the driver to those specific differences, which would provide a concrete 
example of where the dmabuf-fences, or other work may need to be 
expanded, or if maybe the sync driver is the better approach.

I've gone through the Android tree and reworked the sync driver to live 
in staging, while still preserving the full patch history/authorship. 
You can checkout the reworked patch queue here:
  http://git.linaro.org/gitweb?p=people/jstultz/android-dev.git;a=shortlog;h=refs/heads/dev/sync-staging

If folks would take a look and let me know what they think of the 
changes as well as what they think about pushing it to staging, or other 
ideas for how to improve collaboration so we can have common interfaces 
here, I'd appreciate it.

Also note: I've done this so far without any feedback from the Android 
devs (despite my reaching out to Erik a few times recently), so if they 
object to pushing it to staging, in deference to it being their code 
I'll back off, even though I do think it would be good to have the code 
get more visibility upstream in staging. I don't mean to step on 
anyone's toes. :)

thanks
-john

