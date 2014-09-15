Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaIOJ7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:59:33 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:5987 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbaIOJ7b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:59:31 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Mon, 15 Sep 2014 17:59:27 +0800
Subject: RE: [RFC] arm:extend the reserved mrmory for initrd to be page
	aligned
Thread-Topic: [RFC] arm:extend the reserved mrmory for initrd to be page
	aligned
Thread-Index: Ac/Qx7JtuLhS+rS3QNC767QJQsQoPgAA9jzw
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB491605@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB4915FC@CNBJMBX05.corpusers.net>
 <20140915084616.GX12361@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103D6DB491604@CNBJMBX05.corpusers.net>
 <20140915093014.GZ12361@n2100.arm.linux.org.uk>
In-Reply-To: <20140915093014.GZ12361@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Add more log:
<4>[    0.000000] INITRD unalign phys address:0x02000000+0x0022fb0e
<4>[    0.000000] INITRD aligned phys address:0x02000000+0x00230000
<4>[    0.574868] free_initrd: free initrd 0xc2000000+0xc222fb0e
<4>[    0.579398] free_initrd_mem: free pfn:8192---8752

The inird used memory is still the same as the one passed by bootloads,
I don't change it. It should be safe.


-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
Sent: Monday, September 15, 2014 5:30 PM
To: Wang, Yalin
Cc: 'Will Deacon'; 'linux-kernel@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'; 'linux-mm@kvack.org'; linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] arm:extend the reserved mrmory for initrd to be page aligned

On Mon, Sep 15, 2014 at 05:07:53PM +0800, Wang, Yalin wrote:
> Hi
> 
> I tested it on my phone,
> >From log:
> <4>[    0.000000] INITRD unalign phys address:0x02000000+0x0022fb0e
> <4>[    0.000000] INITRD aligned phys address:0x02000000+0x00230000
> 
> <4>[    0.579474] free_initrd_mem: free pfn:8192---8752
> 
> The tail address is not aligned for most initrd image, This page will 
> not be freed and lost .

Right, so from this I can assume that you only tested it by seeing what the addresses were, and the values used in free_initrd_mem().

What you haven't tested is whether the initrd actually gets used with your changes, which is more what I was interested in given what I found when reading your patch.

--
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up according to speedtest.net.
