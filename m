Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3GIHk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:40:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50742 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:40:55 -0400
Date: Tue, 9 Jul 2013 15:40:39 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btusb: fix overflow return values
Message-ID: <20130709074039.GA25268@adam-laptop>
References: <1372941783-30657-1-git-send-email-adam.lee@canonical.com>
 <25CD2206-7B7B-4DAD-A714-A79976C9DB13@holtmann.org>
 <20130709025501.GA6369@adam-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709025501.GA6369@adam-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 10:55:01AM +0800, Adam Lee wrote:
> On Mon, Jul 08, 2013 at 11:50:54AM -0700, Marcel Holtmann wrote:
> > Hi Adam,
> > 
> > > PTR_ERR() returns a long type value, but btusb_setup_intel() and
> > > btusb_setup_intel_patching() should return an int type value.
> > > 
> > > This bug makes the judgement "if (ret < 0)" not working on x86_64
> > > architecture systems, leading to failure as below, even panic.
> > > ...
> > > For not affecting other modules, I choose to modify the return values
> > > but not extend btusb_setup_intel() and btusb_setup_intel_patching()'s
> > > return types. This is harmless, because the return values were only
> > > used to comparing number 0.
> > 
> > there are tons of examples in various subsystems and drivers where we
> > return PTR_ERR from a function calls returning int.
> > 
> > So I wonder what is actually going wrong here. If this is x86_64
> > specific problem with PTR_ERR vs int, then we should have this problem
> > everywhere in the kernel.
> 
> Hi, Marcel
> 
> I see you point, the difference between here and other subsystems are:
> 
> 1, it returns -PTR_ERR() here but all other places return PTR_ERR(), I
> checked.
> 2, the judgement is "if (ret < 0)" here but other places are "if (ret)".
> 
> I'm not saying other subsystems are 100% right, but here, returning
> -PTR_ERR() and checking "if (ret < 0)" make the judgement broken much
> much more easily.
> 
> I attached a testing C file, run it on x86_64, you will see the bug.
> 
> PS, about other subsystems, I also think returning PTR_ERR() from a
> function calls returning int considered harmful sometimes, will talk
> about that in other thread.

Hi, all

After diving into the err.h, I realized this patch contains some
modifications which are actually not necessary. Will submit a v2
version and explain.

PS, other subsystems are using it right, this not.

-- 
Regards,
Adam Lee
Hardware Enablement
