Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3BFNMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:12:20 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:46995 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3BFNMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:12:16 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 6 Feb 2013 13:11:56 +0000
X-Google-Sender-Auth: 9fvcGwC3_KvdjIPcd6FF7v0WMms
Message-ID: <CACxGe6sCBCGfLDAGVRgP3cnmE+oyXBDdPeVXVCqrsvCh13yPiw@mail.gmail.com>
Subject: Heads up on a device tree change
To: linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I've just pushed out a change which cleans up platform device
registration to use the same path whether or not the device tree is
used. It should be safe, but there is a risk of breakage on powerpc
platforms.

The patch has two effects of note:
- DT generated platform devices move from /sys/devices to under
/sys/devices/platform. Userspace *should* be okay with this, but if
there are any problems then I can post a workaround patch that keeps
DT generiated platform_devices in the current location.
- Resources on platform_devices get registered so they appear in
/proc/iomem and /proc/ioports and so that device drivers get the added
protection of request_region. This will cause breakage on device trees
nodes with partially overlapping memory regions. (ie. 0x100..0x1ff and
0x180..0x27f). I also have a workaround for this, but I doubt that it
will be necessary.

I'm not worried about it, but it is a sufficiently visible change that
I want you to be aware that it is there.

g.

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
