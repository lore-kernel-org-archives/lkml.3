Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaE1Ct1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:49:27 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34147 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaE1Ct0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:49:26 -0400
Message-ID: <1401245361.5049.6.camel@cyc>
Subject: Re: [RFC PATCH 0/3] RAS: Correctable Errors Collector thing
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Date: Wed, 28 May 2014 10:49:21 +0800
In-Reply-To: <1401197235-13440-1-git-send-email-bp@alien8.de>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Borislav Petkov <bp@suse.de>
> 
> Hi all,
> 
> this is something Tony and I have been working on behind the curtains
> recently. Here it is in a RFC form, it passes quick testing in kvm. Let
> me send it out before I start hammering on it on a real machine.
> 
> More indepth info about what it is and what it does is in patch 1/3.
> 
> As always, comments and suggestions are most welcome.
> 
> Thanks.

What's the point of this patch set?
My understanding is that if there are some(COUNT_MASK) corrected DRAM
ECC errors for a specific page frame, we can believe that the page frame
is so ill that it should be isolated as soon as possible.

The question is: memory_failure can not be used for isolating the page
frame which is being used by kernel, because it just poison the page and
IGNORED. memory_failure is mostly used for handling AR/AO type errors
related to the page frame which the userspace tasks are using now.

Although the relative page frame is very ill, it is not dead and can
still work. However, memory_failure may kill the userspace tasks,
especially for those page frames that are holding dynamic data rather
than file-backed(file/swap) data.

So I do not think that it is a good idea to directly use memory_failure
in this patch set. 

thx!
cyc


