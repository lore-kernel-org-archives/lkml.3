Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbaCRRN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:13:59 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34982 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbaCRRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:13:57 -0400
Subject: [PATCH] Remove GART aperture from iomem_resource
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Aaron Durbin <adurbin@google.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ingo Molnar <mingo@redhat.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jouni =?utf-8?b?TWV0dMOkbMOk?= <jtmettala@gmail.com>
Date: Tue, 18 Mar 2014 11:13:52 -0600
Message-ID: <20140318170841.8189.7972.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for a regression exposed by an AGP patch I merged in
v3.14-rc1.  Assuming nobody complains, I'd like to ask Linus to pull
it ASAP, before v3.14 releases.

I think it's correct, but I'd sure appreciate it if an AGP expert could
check this out and confirm my belief that the GART aperture I'm removing is
actually *bus* addresses, not CPU addresses (though they happen to be
identical in many systems).

---

Bjorn Helgaas (1):
      Revert "[PATCH] Insert GART region into resource map"


 arch/x86/kernel/aperture_64.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)
