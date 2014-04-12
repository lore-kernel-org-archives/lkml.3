Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaDLWlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 18:41:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57540 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbaDLWlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 18:41:46 -0400
Message-ID: <5349C119.7050208@zytor.com>
Date: Sat, 12 Apr 2014 15:41:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: New Defects reported by Coverity Scan for Linux
References: <5348ea4572e7_5d4d7ac86c27677@209.249.196.67.mail> <CAErSpo6r3Xw8fZ7eaW=8Mg9EabtPUAOQU8ExGt4aYL--+OnLgA@mail.gmail.com> <20140412214145.GL18465@intel.com>
In-Reply-To: <20140412214145.GL18465@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2014 02:41 PM, Ville Syrjälä wrote:
> On Sat, Apr 12, 2014 at 07:29:29AM -0600, Bjorn Helgaas wrote:
>> FYI, looks like these were added by a4dff76924fe ("x86/gpu: Add Intel
>> graphics stolen memory quirk for gen2 platforms").
> 
> Some of the affected gen2 platforms do support up to 2GB of RAM which
> means that if the sign extension were to happen they could hit this.
> However I believe all gen2 platforms are 32bit which AFAIK makes size_t 
> 32 bits. So looks like we can't hit this in practice..
> 
> But if someone were to change the return type to 64bits we'd
> be in real danger, so I guess it would be better to fix the bug
> anyway.
> 
> -#define KB(x)  ((x) * 1024)
> +#define KB(x)  ((x) * 1024U)
> should be sufficient to eliminate the problem. If someone wants me to
> put that into a real patch and send it out let me know.
> 

Please do, but make it UL (in the Linux kernel context, unsigned long is
always equivalent to size_t/pointer size.)

	-hpa


