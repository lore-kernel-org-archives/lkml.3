Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaJAKKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:10:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39653 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaJAKK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:10:29 -0400
Date: Wed, 1 Oct 2014 12:10:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141001101024.GA18271@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
 <1411460354.25617.3.camel@debian>
 <20140929120546.GB6495@pd.tnic>
 <1412037578.21488.11.camel@debian>
 <20140930072553.GA4639@pd.tnic>
 <1412070991.16556.12.camel@cyc>
 <20140930100940.GD4639@pd.tnic>
 <1412141164.21488.39.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412141164.21488.39.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 01:26:04PM +0800, Chen Yucong wrote:
> On Tue, 2014-09-30 at 12:09 +0200, Borislav Petkov wrote:
> > 
> > Now let me repeat my question: how are you testing your patches?
> > 
> There are no any hardware facilities that can help me to inject some
> MCE errors. So I have to modify the kernel source code for testing my
> patches.
> 
> My method is based on the `mce-injection' that is better suited to 
> Intel processors. So I have replaced rdmsrl/wrmsrl/rdmsr_safe with
> mce_rdmsrl/mce_wrmsrl/mce_rdmsr_safe in mce_amd.c. But I use a new
> kernel module for error injection instead of writing /dev/mcelog.
> 
> For more detailed information about testing, you can refer the 
> attachments.

Right, so you modprobe/rmmod when you inject, I see.

We actually have some functionality to test the decoding of MCEs, take a
look at drivers/edac/mce_amd_inj.c. I have patches somewhere which allow
it to raise real MCEs but didn't have the need to merge them yet - I
could try to dust them off...

I also have a patch converting this module to debugfs as sysfs is not
the right fs it should be using for injecting. Then it might be easy to
extend it to inject all kinds of errors into MCA... Also maybe do both
real injection into the hardware (dangerous) and do the fake thing which
mce-inject does. Oh well.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
