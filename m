Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbaIFJDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 05:03:39 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45379 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIFJDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 05:03:34 -0400
Date: Sat, 6 Sep 2014 10:03:31 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: matt.fleming@intel.com, Mark Rustad <mark.d.rustad@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: Resolve some shadow warnings
Message-ID: <20140906090331.GQ3001@console-pimps.org>
References: <1409967292-31441-1-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409967292-31441-1-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep, at 06:34:52PM, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> It is a really bad idea to declare variables or parameters that
> have the same name as common types. It is valid C, but it gets
> surprising if a macro expansion attempts to declare an inner
> local with that type. Change the local names to eliminate the
> hazard.
 
Oops, good catch. Could you include a copy of the compiler shadow
warnings in the commit log? I'm guessing this bug is highlighted with
-Wshadow? How did you discover this problem?

> Change s16 => ps16, s8 => ps8.
 
Hmm... Instead, could you change it to str16 and str8? s8/s16 were
clearly misguided names in the first place, and it's not immediatealy
obvious to me that a 'ps16' would represent "pointer to 16-bit string".

-- 
Matt Fleming, Intel Open Source Technology Center
