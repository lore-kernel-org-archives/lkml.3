Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3HKQuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:50:35 -0400
Received: from mout.gmx.net ([212.227.17.22]:55043 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab3HKQue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:50:34 -0400
Date: Sun, 11 Aug 2013 18:50:31 +0200
From: Andreas Werner <wernerandy@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: question about ioremap_cache and PAT
Message-ID: <20130811165031.GA4439@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:V5rblE5I16Y+X1XcbXrTGlhgddhg2AWGDwNj+xF6/hsH9jNi2S0
 tF1C+TjOj2IW+rC2bEbRDU2nv2abk84CdF/5vHAyS91Vb6Ozxa8+aF5mNMY+nRiyM72Eaqt
 r0ms7O3WM7BdMcAO+VXioZoS19knnK70BQeYjDmXSlLFZvAHJ7Np3Bx2c2Lo9zDHGcC98Hp
 QKOSuhdUQFDE0/R+P0J/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi i have a question about ioremap_cache and the resulting PAT attribute on X86 system. If I configure the mtrr to Write-Through for an adress range, and call ioremap_cache to map the mmio, the resulting PAT attribute is set to UC.
If I check the Intel document IA-32 SDM vol 3a, the resulting PAT attribute should be WB.

I found the function pat_x_mtrr_type in arch/x86/mm/pat.c where the resulting attribute is returned. There will be always UC return expect if the MTRR is set to WB.

Why is there only WB or UC returned? In the Intel document there are a lot of combinations "allowed".

I need a Attribute of WT, so what i did is to modify the pat_x_mtrr_type function to return also WB if the MTRR is set to WT.   

Is this a solution to solve that or whats the reasion why the kernel doesn´t support this combination?

Best regards

B
B
B
B
B
B
B
B
B
B
B
B
B
B
B
B
B
B
A
A
A
A
A
A
A
A
A
A
A
A
A
A
A
B
B
B
Best regards
