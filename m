Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaLCRGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:06:18 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:58928 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaLCRGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:06:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mason <mpeg.blue@free.fr>, Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Creating 16 MB super-sections for MMIO
Date: Wed, 03 Dec 2014 18:06:08 +0100
Message-ID: <2452742.elcJohDinR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <547F1C11.5090408@free.fr>
References: <547D97A5.4090302@free.fr> <20141203103211.GB7373@e104818-lin.cambridge.arm.com> <547F1C11.5090408@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:r+ipLw9WE0eo1K0cfk2JJ9xumS0cIe6czXgTLfEVahD
 3jqIM1X0nz1WFfqRxHy1nzBnlGhxp/HWmZepDN01LNZrG/wgGo
 ySDr4lh771OUpUq/RGX+Dupqj+4dQOb9G3dMVmbs4kb3wk8qOX
 PgNPGXhqn7T0HA9Lhn6VbZgFrX4SpTah3JE4uz9fQ/23eru4Zk
 RkSHBAOagICZ48ViL1iK9sa3SziqKP4TAMtykY5IAAjMFQMANg
 8tSak/oObvPMWxgrwd7350A0q7U+5l2f8+A6hMqkQpQFuPdj16
 D0CO8dAqxLXb86ZdxEFvqjvqiTytGkhKptlhPWUTsz/vbjoG9F
 XtBRaCd9P4Fv74M7SyfU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 15:20:01 Mason wrote:
> 
> As far as I could tell, Linux does not create a super-section in the
> case outlined above. Perhaps I misread the source code?

I believe you are right, and I also agree that in theory implementing
what you say (both 64k and 16M mappings) can only help, but it's not
obvious if this makes a measurable difference in the end.

MMIO register accesses are usually slow for other reasons, and
they tend to be rare, so it's possible that you won't be able
to ever tell a difference because the MMIO TLB often gets evicted
by user mappings between accesses to different 1MB sections,
and the timing difference between a TLB-hot and cold MMIO access
might not be that great (depending on the latency of a particular
register).

I don't think there would be any objections to doing superpage
or supersection mappings for early page tables if you can show
any benefit whatsoever, but it may be hard to come up with a
scenario where it's actually measurable.

	Arnd
