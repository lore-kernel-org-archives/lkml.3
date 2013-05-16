Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3EPS6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:58:23 -0400
Received: from mout.gmx.net ([212.227.17.22]:53663 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3EPS6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:58:20 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18kDuYzMdAkgmlQrh3z/okD3jCDhY38L5jegiP96S
	dJ5ngP/y60BOA1
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics st33 driver SPI
Date: Thu, 16 May 2013 21:03:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        "Jean-Luc BLANC" <jean-luc.blanc@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>, Sirrix AG <tpmdd@sirrix.com>
References: <1368625999-1963-1-git-send-email-mathias.leblanc@st.com> <201305160029.07073.PeterHuewe@gmx.de> <35286B1AE75A7C47BFF0870081A31B4B45A8A84AF6@SAFEX1MAIL4.st.com>
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B45A8A84AF6@SAFEX1MAIL4.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305162103.11996.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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






