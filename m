Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936069Ab3DHUdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:33:13 -0400
Received: from www.sr71.net ([198.145.64.142]:44193 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935959Ab3DHUdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:33:12 -0400
Message-ID: <51632988.8070006@sr71.net>
Date: Mon, 08 Apr 2013 13:33:12 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, x86@kernel.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        khlebnikov@openvz.org, bhelgaas@google.com
Subject: Re: [PATCH] do not try to sync identity map for non-mapped pages
References: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com> <20130407133346.GD31299@pd.tnic> <51619FFF.30705@linux.intel.com>
In-Reply-To: <51619FFF.30705@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 09:34 AM, H. Peter Anvin wrote:
> On 04/07/2013 06:33 AM, Borislav Petkov wrote:
>> looks like we haven't whacked all the moles - I keep seeing this when
>> testing 32-bit builds in qemu on latest Linus + tip. I'd guess this is
>> still that /dev/mem accessing thing called wdm.
>>
>> I'm still wondering though whether we should BUG_ON on a /dev/mem
>> access?
> 
> We shouldn't, no.  /dev/mem really needs to be fixed along a bunch of
> axes.  Yes, it is privileged and extra creepy, but it should either work
> or it should fail cleanly.

I've got a set sitting around collecting dust that I've got to post.  It
should at least restore sanity for /dev/mem on x86.  I'll have it out
for some initial review tomorrow.
