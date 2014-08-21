Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaHUIlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:41:44 -0400
Received: from mx0.aculab.com ([213.249.233.131]:44321 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753929AbaHUIlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:41:42 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mark Einon'" <mark.einon@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/8] staging: et131x: Use for loop to initialise
 contiguous macstat registers to zero
Thread-Topic: [PATCH 4/8] staging: et131x: Use for loop to initialise
 contiguous macstat registers to zero
Thread-Index: AQHPvMTluMi4d3BivkeMsizcxFH6/JvavMLw
Date: Thu, 21 Aug 2014 08:40:20 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1747D483@AcuExch.aculab.com>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
 <1408573078-9320-5-git-send-email-mark.einon@gmail.com>
In-Reply-To: <1408573078-9320-5-git-send-email-mark.einon@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon
> Replace a long list of contiguous writel() calls with a for loop iterating
> over the same address values.
> 
> Also remove redundant comments on the macstat registers, the variable names
> are good enough.
...
> -	writel(0, &macstat->txrx_0_64_byte_frames);
...
> -	writel(0, &macstat->carry_reg2);
> +	/* initialize all the macstat registers to zero on the device  */
> +	for (reg = &macstat->txrx_0_64_byte_frames;
> +	     reg <= &macstat->carry_reg2; reg++)
> +		writel(0, reg);
...
>  struct macstat_regs {			/* Location: */
>  	u32 pad[32];			/*  0x6000 - 607C */
> 
> -	/* Tx/Rx 0-64 Byte Frame Counter */
> +	/* counters */
>  	u32 txrx_0_64_byte_frames;	/*  0x6080 */
> -
> -	/* Tx/Rx 65-127 Byte Frame Counter */
>  	u32 txrx_65_127_byte_frames;	/*  0x6084 */

I think it would be best to also convert the stats counters to an array.

	David



