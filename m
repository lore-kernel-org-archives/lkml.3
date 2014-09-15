Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbaIOK6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:58:20 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:9530 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbaIOK6T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:58:19 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Mon, 15 Sep 2014 18:58:15 +0800
Subject: RE: [RFC] arm:extend the reserved mrmory for initrd to be page
	aligned
Thread-Topic: [RFC] arm:extend the reserved mrmory for initrd to be page
	aligned
Thread-Index: Ac/Q0CAgcR9cxjZaRZq7zU4LQXJRMAAA7kLg
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB491608@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB4915FC@CNBJMBX05.corpusers.net>
 <20140915084616.GX12361@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103D6DB491604@CNBJMBX05.corpusers.net>
 <20140915093014.GZ12361@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103D6DB491605@CNBJMBX05.corpusers.net>
 <20140915101632.GA12361@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103D6DB491606@CNBJMBX05.corpusers.net>
 <20140915103013.GB12361@n2100.arm.linux.org.uk>
In-Reply-To: <20140915103013.GB12361@n2100.arm.linux.org.uk>
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

Oh, I see,
I don't consider non-of platform kernels,
I will send V2 patch for this .

Thanks

-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
Sent: Monday, September 15, 2014 6:30 PM
To: Wang, Yalin
Cc: 'Will Deacon'; 'linux-kernel@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'; 'linux-mm@kvack.org'; linux-arm-msm@vger.kernel.org
Subject: Re: [RFC] arm:extend the reserved mrmory for initrd to be page aligned

On Mon, Sep 15, 2014 at 06:22:12PM +0800, Wang, Yalin wrote:
> Oh, I see your meaning,
> Yeah , my initrd is a cpio image,
> And it can still work after apply this patch.

Okay, that's what I wanted to know.  However, I believe your patch to be incorrect.  You delete the assignments to initrd_start and initrd_end in arm_memblock_init(), which will result in non-OF platforms having no initrd.

The reason is that OF platforms set initrd_start and initrd_size from the OF code (drivers/of/fdt.c), but ATAG platforms only set our private
phys_* versions.

The reason I went with phys_* stuff was to permit better verification of the addresses passed - that the addresses were indeed memory locations before passing them through something like __va().

--
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up according to speedtest.net.
