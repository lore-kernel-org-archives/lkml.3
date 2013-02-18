Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab3BRTip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:38:45 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33995 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3BRTio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:38:44 -0500
Message-ID: <512282FF.2050005@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 13:37:35 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Mason <ric.masonn@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv5 0/8] zswap: compressed swap caching
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com> <511EFB05.3020700@gmail.com>
In-Reply-To: <511EFB05.3020700@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021819-9360-0000-0000-000010BD64A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 09:20 PM, Ric Mason wrote:
> On 02/14/2013 02:38 AM, Seth Jennings wrote:
<snip>
>>
>> Some addition performance metrics regarding the performance
>> improvements and I/O reductions that can be achieved using zswap as
>> measured by SPECjbb are provided here:
>>
>> http://ibm.co/VCgHvM
> 
> I see this link.  You mentioned that "When a user enables zswap and
> the hardware accelerator, zswap simply passes the pages to be
> compressed or decompressed off to the accelerator instead of
> performing the work in software". Then how can user enable hardware
> accelerator, there are option in UEFI or ... ?

zswap uses the cryptographic API for accessing compressor modules.  In
the case of Power7+, we have a crypto API driver (crypto/842.c) which
wraps calls to the real driver (drivers/crypto/nx/nx-842.c) which
makes the hardware calls.

To use a compressor module, use the zswap.compressor attribute on the
kernel parameter.  For P7+, for exmaple:

zswap.compressor=842

> 
>> These results include runs on x86 and new results on Power7+ with
>> hardware compression acceleration.

Thanks,
Seth

