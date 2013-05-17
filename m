Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3EQMau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:30:50 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:39823 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab3EQMat convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:30:49 -0400
From: Mathias LEBLANC <Mathias.LEBLANC@st.com>
To: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>
Cc: Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>, Sirrix AG <tpmdd@sirrix.com>
Date: Fri, 17 May 2013 14:26:04 +0200
Subject: RE: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver
 SPI
Thread-Topic: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver
 SPI
Thread-Index: Ac5SZ1VfcifWQ6ZxRuCazwclkhgOAwAkl4Vd
Message-ID: <35286B1AE75A7C47BFF0870081A31B4B49E30480E2@SAFEX1MAIL4.st.com>
References: <1368625999-1963-1-git-send-email-mathias.leblanc@st.com>
 <201305160029.07073.PeterHuewe@gmx.de>
 <35286B1AE75A7C47BFF0870081A31B4B45A8A84AF6@SAFEX1MAIL4.st.com>,<201305162103.11996.PeterHuewe@gmx.de>
In-Reply-To: <201305162103.11996.PeterHuewe@gmx.de>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, 

Thanks for this new function.
I had already changed the for loop but i would to be sure that it's the best way and that you expected.

Don't hesitate if you have any other recommendation or any comments for this driver.

Regards,

Mathias Leblanc
________________________________________
From: Peter Hüwe [PeterHuewe@gmx.de]
Sent: 16 May 2013 21:03
To: tpmdd-devel@lists.sourceforge.net
Cc: Mathias LEBLANC; Jean-Luc BLANC; linux-kernel@vger.kernel.org; Rajiv Andrade; Sirrix AG
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI

Hi Matthias:

> Regarding the while loop, I don't see how can I check the number of dummy
> byte differently?


Checking the number of dummy bytes is fine -
in line #144 you check it with a while loop which looks fine
in line #198 you check it with a for loop with an empty body, which in my
opinion looks less nice than the while in #144.

So simply replace the second instance in #198 and I'm happy with that part ;)

Maybe also have a look at memchr_inv

/**
 * memchr_inv - Find an unmatching character in an area of memory.
 * @start: The memory area
 * @c: Find a character other than c
 * @bytes: The size of the area.
 *
 * returns the address of the first character other than @c, or %NULL
 * if the whole buffer contains just @c.
 */
void *memchr_inv(const void *start, int c, size_t bytes)



so #198 would look something like:
nbr_dummy_bytes = memchr_inv (xfer.rx_buf+nbr_dummy_bytes,
                                        0,
                                         total_length-nbr_dummy_bytes) - xfer.rx_buf;

But I'm not sure whether that's more readable, maybe give it a try.
 I'm also fine with the while loop.


Peter






