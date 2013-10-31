Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3JaGtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:49:45 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:54882 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3JaGtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:49:43 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>, Greg KH <gregkh@linuxfoundation.org>
CC: "w.d.hubbs@gmail.com" <w.d.hubbs@gmail.com>,
        "chris@the-brannons.com" <chris@the-brannons.com>,
        "kirk@reisers.ca" <kirk@reisers.ca>,
        "samuel.thibault@ens-lyon.org" <samuel.thibault@ens-lyon.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "speakup@braille.uwo.ca" <speakup@braille.uwo.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: include: asm: define empty SERIAL_PORT_DFNS in
 serial.h
Thread-Topic: [PATCH] arc: include: asm: define empty SERIAL_PORT_DFNS in
 serial.h
Thread-Index: AQHO1drspo9ooUc5PUOHxUtmMZbeyg==
Date: Thu, 31 Oct 2013 06:47:22 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751538E6@IN01WEMBXA.internal.synopsys.com>
References: <5267406C.9030805@asianux.com>
 <20131025052926.GA26786@kroah.com> <526BC113.3040003@asianux.com>
 <5271B1D2.6020301@asianux.com> <5271B609.90805@asianux.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 07:15 AM, Chen Gang wrote:
> For some architectures (e.g. arc, openrisc), BASE_BAUD isn't constant
> And SERIAL_PORT_DFNS always use BASE_BAUND, and also all drivers use
> SERIAL_PORT_DFNS to initialize static variables, statically.
>
> So need define SERIAL_PORT_DFNS as empty to tell drivers they don't
> support SERIAL_PORT_DFNS (mostly like frv and parisc did), or can not
> pass compiling
>
> The related error (allmodconfig for arc with gcc-4.8.0):
>
>     CC [M]  drivers/staging/speakup/serialio.o
>   drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
>     SERIAL_PORT_DFNS
>     ^
>   drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[0].baud_base')
>   drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
>   drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[1].baud_base')
>   drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
>   drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[2].baud_base')
>   drivers/staging/speakup/serialio.c:12:2: error: initializer element is not constant
>   drivers/staging/speakup/serialio.c:12:2: error: (near initialization for 'rs_table[3].baud_base')
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

NAK - as mentioned in prev email please fix the driver.

-Vineet
