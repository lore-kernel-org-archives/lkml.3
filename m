Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3IRNfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:35:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3IRNfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:35:39 -0400
Message-ID: <1379511332.1817.45.camel@deneb.redhat.com>
Subject: Re: [PATCH 01/28] c6x: use boot_command_line instead of private
 c6x_command_line
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Date: Wed, 18 Sep 2013 09:35:32 -0400
In-Reply-To: <1379372965-22359-2-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
	 <1379372965-22359-2-git-send-email-robherring2@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 18:08 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Save some pointless copying of the kernel command line and just use
> boot_command_line instead.
> 
> Also remove default_command_line as it is not referenced anywhere, and
> the DT code already handles the default command line.
> 

The default_command_line is leftover cruft from the kernel before it was
upstreamed. It was a mechanism to place the commandline at a known fixed
offset in the Image. It was needed for simple (serial eeprom based)
loaders which didn't know about DT. Anyway, bits of that support are
missing, so I don't see a reason to keep it around. If anyone complains
we can add it back in as a completely functional patch. There is also
a fragment of arch/c6x/kernel/vmlinux.lds.S which should also be
removed:

diff --git a/arch/c6x/kernel/vmlinux.lds.S b/arch/c6x/kernel/vmlinux.lds.S
index 279d807..5a6e141 100644
--- a/arch/c6x/kernel/vmlinux.lds.S
+++ b/arch/c6x/kernel/vmlinux.lds.S
@@ -37,12 +37,6 @@ SECTIONS
 		_vectors_end = .;
 	}
 
-	. = ALIGN(0x1000);
-	.cmdline :
-	{
-		*(.cmdline)
-	}
-
 	/*
 	 * This section contains data which may be shared with other
 	 * cores. It needs to be a fixed offset from PAGE_OFFSET


