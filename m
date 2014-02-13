Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaBMKbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:31:18 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:51954 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbaBMKbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:31:15 -0500
Date: Thu, 13 Feb 2014 10:31:09 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string
 handling
Message-ID: <20140213103109.GB20717@console-pimps.org>
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com>
 <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com>
 <20140212020010.GB21033@windriver.com>
 <alpine.DEB.2.02.1402111821510.13509@chino.kir.corp.google.com>
 <52FB8BEB.5020506@windriver.com>
 <52FB9807.40706@windriver.com>
 <alpine.DEB.2.02.1402121357450.27082@chino.kir.corp.google.com>
 <52FBF5DD.3030407@windriver.com>
 <alpine.DEB.2.02.1402121508430.20539@chino.kir.corp.google.com>
 <52FC0439.7020508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FC0439.7020508@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb, at 03:31:05PM, H. Peter Anvin wrote:
> 
> The real answer IMO ought to be that since arch/x86/boot/string.c is now
> used separately from boot.h (eboot.c which includes efi-stub-helper.c
> does *not* include boot.h) we may have to move those string functions
> into a separate header file.
> 
> Matt, do you have any opinions here?
 
This makes sense to me. Perhaps arch/x86/boot/lib/string.c which would
be useable by both arch/x86/boot/*.c and arch/x86/boot/compressed/*.c?

-- 
Matt Fleming, Intel Open Source Technology Center
