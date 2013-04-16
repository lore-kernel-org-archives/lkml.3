Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936137Ab3DPRvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:51:37 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:41350 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936039Ab3DPRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:51:35 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.125.78]
In-Reply-To: <20130416100715.cd726b96944237ef975ebe7d@canb.auug.org.au>
References: <CAK=WgbY=4rosYr2g3fYYk6WrqXjN7f=5Dk5+D-h3cWrOtVmNag@mail.gmail.com>
 <20130416100715.cd726b96944237ef975ebe7d@canb.auug.org.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 16 Apr 2013 20:51:13 +0300
Message-ID: <CAK=WgbbVP+3eugev8szRBCV84uZLdKP6QXAH_Fr89SXDs-V5GQ@mail.gmail.com>
Subject: Re: adding rpmsg.git to linux next
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Tivy, Robert" <rtivy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Apr 16, 2013 at 3:07 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Mon, 15 Apr 2013 09:28:17 +0300 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> Could you please add:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git#for-next
>>
>> to linux-next to include new stuff coming from Rob?
>
> Well, you could tell me something about it.  Like what is in it and how
> it will be merged up to Linus.  Does this have anything to do with the
> remoteproc tree I already include?  Who is the official maintainer (there
> is no mention of drivers/rpmsg in the MAINTAINERS file).

Sorry for not mentioning this.

This tree isn't new and is being used to send pull requests to Linus
for some time. I guess that most (all?) of the pull requests contained
fixes which needed no linux-next presence, so it never occurred to me
the tree isn't part of linux-next.

Some background:

Rpmsg is a virtio-based messaging bus that allows kernel drivers to communicate
with entities running on remote processors available on the system. In
turn, drivers could then
expose appropriate user space interfaces, if needed.

Rpmsg is essentially a multiplexer providing communication channels
which rpmsg drivers utilizes; it does not handle the physical state of
the remote processor, and in fact is completely decoupled from
remoteproc, which does focus on the physical state of the remote
processor (but has no communications aspect). For much more
information, please see Documentation/rpmsg.txt.

I maintain rpmsg (by sending pull requests to Linus), and for some
reason never added a MAINTAINERS entry for it. I can fix that quite
easily, let me know if this helps:

commit d8115db52b99eefb99bcbf992edc349e691b4ca7
Author: Ohad Ben-Cohen <ohad@wizery.com>
Date:   Tue Apr 16 20:34:49 2013 +0300

    MAINTAINERS: add rpmsg entry

    People and scripts look for this.

    Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9561658..eaca6c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6604,6 +6604,14 @@ F:       drivers/remoteproc/
 F:     Documentation/remoteproc.txt
 F:     include/linux/remoteproc.h

+REMOTE PROCESSOR MESSAGING (RPMSG) SUBSYSTEM
+M:     Ohad Ben-Cohen <ohad@wizery.com>
+T:     git git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git
+S:     Maintained
+F:     drivers/rpmsg/
+F:     Documentation/rpmsg.txt
+F:     include/linux/rpmsg.h
+
 RFKILL
 M:     Johannes Berg <johannes@sipsolutions.net>
 L:     linux-wireless@vger.kernel.org

Hope this all helps, please let me know if anything else is needed.

Thanks,
Ohad.
