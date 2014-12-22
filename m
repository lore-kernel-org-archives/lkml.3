Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaLVUPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:15:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35986 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbaLVUPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:15:45 -0500
Date: Mon, 22 Dec 2014 21:15:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tony.luck@intel.com,
        dougthompson@xmission.com, mchehab@osg.samsung.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        dave.hansen@linux.intel.com, mgorman@suse.de, bp@suse.de,
        riel@redhat.com, jacob.w.shin@gmail.com
Subject: Re: [PATCH 0/3] Fix MCE handling for AMD multi-node processors
Message-ID: <20141222201542.GB1942@pd.tnic>
References: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 02:10:09PM -0600, Aravind Gopalakrishnan wrote:
> When a MCE happens that is to be logged onto bank 4 of AMD multi-node
> processors, they are reported only to corresponding node base core of
> the cpu on which the error occurred.
> 
> Refer D18F3x44[NbMcaToMstCpuEn] on BKDGs of Fam10h and later for

Let me try to understand this correctly:

Does that mean that we could fix this by simply doing:

D18F3x44[NbMcaToMstCpuEn]=0b

on each NB?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
