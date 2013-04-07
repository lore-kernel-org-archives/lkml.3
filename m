Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055Ab3DGQeK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 12:34:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:34832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934025Ab3DGQeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 12:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,423,1363158000"; 
   d="scan'208";a="314096798"
Message-ID: <51619FFF.30705@linux.intel.com>
Date: Sun, 07 Apr 2013 09:34:07 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        x86@kernel.org, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        khlebnikov@openvz.org, bhelgaas@google.com
Subject: Re: [PATCH] do not try to sync identity map for non-mapped pages
References: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com> <20130407133346.GD31299@pd.tnic>
In-Reply-To: <20130407133346.GD31299@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 06:33 AM, Borislav Petkov wrote:
> 
> looks like we haven't whacked all the moles - I keep seeing this when
> testing 32-bit builds in qemu on latest Linus + tip. I'd guess this is
> still that /dev/mem accessing thing called wdm.
> 
> I'm still wondering though whether we should BUG_ON on a /dev/mem
> access?
> 

We shouldn't, no.  /dev/mem really needs to be fixed along a bunch of
axes.  Yes, it is privileged and extra creepy, but it should either work
or it should fail cleanly.

	-hpa

