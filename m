Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbbAWRCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:02:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39466 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbbAWRCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:02:49 -0500
Date: Fri, 23 Jan 2015 18:02:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/3] x86, crash: Allocate enough low-mem when
 crashkernel=high
Message-ID: <20150123170243.GG22635@pd.tnic>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-4-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420555874-11506-4-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:51:14PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When the crashkernel is loaded above 4GiB in memory the
> first kernel only allocates 72MiB of low-memory for the DMA
> requirements of the second kernel. On systems with many
> devices this is not enough and causes device driver
> initialization errors and failed crash dumps. Set this
> default value to 256MiB to make sure there is enough memory

This upper limit of 256 looks arbitrary. Are we going to raise it a
couple of years from now if it becomes insufficient then?

It probably won't be easy but is there some more reliable way to
allocate enough memory for DMA on a say per-system basis or whatever...?
Probably not but let me ask it anyway.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
