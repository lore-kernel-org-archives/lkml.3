Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946743Ab3BHRHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:07:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:16885 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760098Ab3BHRHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:07:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,630,1355126400"; 
   d="scan'208";a="282777693"
Message-ID: <511530AC.1070203@linux.intel.com>
Date: Fri, 08 Feb 2013 09:06:52 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: kbuild test robot <fengguang.wu@intel.com>,
        =?ISO-8859-1?Q?Ville_Sy?= =?ISO-8859-1?Q?rj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sound/pci/asihpi/hpioctl.c:125:6: warning: cast to pointer from
 integer of different size
References: <51143ca4.bNX7TobZ2rDrz0zj%fengguang.wu@intel.com> <511460B7.4030007@linux.intel.com> <20130208152858.GU17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130208152858.GU17833@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 07:28 AM, Russell King - ARM Linux wrote:
> 
> Whether that's safe for x86 or not, I don't know, but my suspicions are
> that it's unsafe on x86 as it's possible to refer to the various bytes/
> half-words of eax separately.
> 
> So, I came to the conclusion that if x86 remains a problem, there's
> little point supporting it on ARM.
> 

It is possible to access bytes separately, but gcc generally doesn't.
However, whether or not that can be relied upon safely is a tricky question.

It *is* also worth nothing that the x86 ABI does allow two words to be
returned in registers from a normal C function, simply by returning a
structure.  That doesn't solve the problem at hand, though, which is how
to make a type-neutral macro which can handle doublewords...

	-hpa

