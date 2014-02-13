Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaBMOBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:01:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37402 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaBMOBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:01:40 -0500
Message-ID: <52FCD01F.70500@zytor.com>
Date: Thu, 13 Feb 2014 06:01:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: David Rientjes <rientjes@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string handling
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com> <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com> <20140212020010.GB21033@windriver.com> <alpine.DEB.2.02.1402111821510.13509@chino.kir.corp.google.com> <52FB8BEB.5020506@windriver.com> <52FB9807.40706@windriver.com> <alpine.DEB.2.02.1402121357450.27082@chino.kir.corp.google.com> <52FBF5DD.3030407@windriver.com> <alpine.DEB.2.02.1402121508430.20539@chino.kir.corp.google.com> <52FC0439.7020508@zytor.com> <20140213103109.GB20717@console-pimps.org>
In-Reply-To: <20140213103109.GB20717@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 02:31 AM, Matt Fleming wrote:
> On Wed, 12 Feb, at 03:31:05PM, H. Peter Anvin wrote:
>>
>> The real answer IMO ought to be that since arch/x86/boot/string.c is now
>> used separately from boot.h (eboot.c which includes efi-stub-helper.c
>> does *not* include boot.h) we may have to move those string functions
>> into a separate header file.
>>
>> Matt, do you have any opinions here?
>  
> This makes sense to me. Perhaps arch/x86/boot/lib/string.c which would
> be useable by both arch/x86/boot/*.c and arch/x86/boot/compressed/*.c?
> 

That would be fine, but the issue at hand isn't the .c file but the lack
of a corresponding .h file...

	-hpa

