Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaKLPtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:49:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaKLPtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:49:13 -0500
Message-ID: <54638174.50306@redhat.com>
Date: Wed, 12 Nov 2014 16:49:08 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: simplefb device tree bindings enumeration and handover
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today I've had a long discussion with Grant Likely on irc, in the
#devicetree channel, on the devicetree bindings for simplefb.

The 2 topics discussed were enumeration of simplefb nodes, and the
handover to a hw specific driver later in the boot process.

We've come to the following conclusions:

1) Since simplefb nodes represent runtime information they must be sub-nodes
of the chosen node. The primary display node must be named framebuffer0,
additional nodes must be called framebuffer1, etc.

2) If a simplefb node represents the preferred console for user
interaction, then the chosen node's stdout-path property must point to it.

3) Older devicetree files may have a compatible = "simple-framebuffer"
node in a different place, operating systems must first enumerate any
framebuffer# nodes found under chosen and then check for other compatible
nodes.

4) If the devicetree contains nodes for the display hardware used by a simplefb,
then one of the hw nodes must have a property called "framebuffer" pointing to
the framebuffer# node in chosen, so that the operating system knows which
simplefb to disable when handing over control to a driver for the real
hardware. The bindings for the hw nodes must specify which node contains the
framebuffer property.

5) It is advised that devicetree files contain pre-filled, disabled framebuffer#
nodes, so that the firmware only needs to update the mode information and
enable them. This way if e.g. later on support for more display clocks get
added, the simplefb nodes will already contain this info and the firmware
does not need to be updated.

I'll post a patch updating Documentation/devicetree/bindings/video/simple-framebuffer.txt
to reflect this soon.

Regards,

Hans

