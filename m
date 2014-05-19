Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaESB5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:57:19 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34588 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaESB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:57:17 -0400
Message-ID: <1400464540.9630.31.camel@debian>
Subject: Re: [PATCH] x86/mce: Distirbute the clear operation of mces_seen to
 Per-CPU rather than only monarch CPU
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Date: Mon, 19 May 2014 09:55:40 +0800
In-Reply-To: <20140518163508.GA8003@pd.tnic>
References: <1400425504-8821-1-git-send-email-slaoub@gmail.com>
	 <20140518163508.GA8003@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-18 at 18:35 +0200, Borislav Petkov wrote:
> On Sun, May 18, 2014 at 11:05:04PM +0800, Chen Yucong wrote:a
> > mces_seen is a Per-CPU variable which should only be accessed by
> > Per-CPU as possible. So the clear operation of mces_seen should also
> > be lcoal to Per-CPU rather than monarch CPU.
> 
> No, you need to do the cleaning in mce_reign because the monarch cpu has
> to run last after all other cpus have scanned their mce banks.
> 
But all other CPUs also have to wait monarch CPU to exit from mce_end. 
What's the difference between monarch CPU and Per-CPU for clearing
mces_seen? In practice, there is no difference between them. If we use
monarch CPU to clear mces_seen, then Per-CPU variable can not play out
its advantage.

> > Meanwhile, there is also a potential risk that mces_seen will not
> > be be cleared if a timeout occors in mce_end for monarch CPU. As a
> > reuslt, the stale value of mces_seen will reappear on the next mce.
> 
> If that happens, we have a bigger problem.
Well, in that case, why is there a need for time-out machine in MCE
handler?

Any potential risks --both logical and realistic-- should be avoided as
possible if there are no more questions and performance penalty.

thx!
cyc 
> 
> Is that a real issue you're trying to address?



