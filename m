Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3HGFNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:13:43 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52152 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3HGFNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:13:42 -0400
Message-ID: <5201D777.8060303@linux.vnet.ibm.com>
Date: Wed, 07 Aug 2013 10:43:27 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH 00/11] Add compression support to pstore
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420> <51FA3B02.7060004@linux.vnet.ibm.com> <3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com> <CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com> <CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com> <51FFDC8B.7010909@linux.vnet.ibm.com> <CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com> <51FFFFEB.3030907@linux.vnet.ibm.com> <CA+8MBbK9oZJO+RJGC-7riO=Kz=UbRcAvQ-nDi=2GLyvEDpoc7g@mail.gmail.com> <CA+8MBbKA+P4vs3utSKQ-LPMW3ybrWOp=f3FH6ahv1YtwnMm5KA@mail.gmail.com> <5201A9BD.4090503@linux.vnet.ibm.com> <CA+8MBbJS0Dymn4OABi-rW9M5Bw-ZZ6DaEjQOW-oki+4ge4BDtg@mail.gmail.com>
In-Reply-To: <CA+8MBbJS0Dymn4OABi-rW9M5Bw-ZZ6DaEjQOW-oki+4ge4BDtg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080705-3864-0000-0000-000009768FE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Wednesday 07 August 2013 08:55 AM, Tony Luck wrote:
> On Tue, Aug 6, 2013 at 6:58 PM, Aruna Balakrishnaiah
> <aruna@linux.vnet.ibm.com> wrote:
>> The patch looks right. I will clean it up. Does the issue still persist
>> after this?
> Things seem to be working - but testing has hardly been extensive (just
> a couple of forced panics).
>
> I do have one other question. In this code:
>
>>>                   if (compressed && (type == PSTORE_TYPE_DMESG)) {
>>>                           big_buf_sz = (psinfo->bufsize * 100) / 45;
> Where does the magic multiply by 1.45 come from?  Is that always enough
> for the decompression of "dmesg" type data to succeed?

I had this in my cover letter of the series, posting the same from it

Writing to persistent store
----------------------------
Compression will reduce the size of oops/panic report to atmost 45% of its
original size. (Based on experiments done while providing compression support
to nvram by Jim keniston).
Hence buffer of size ( (100/45 approx 2.22) *<registered_buffer> is allocated).
The compression parameters selected based on some experiments:
compression_level = 6, window_bits = 12, memory_level = 4  which achieved a
significant compression of 12 % of uncompressed buffer size tried upto 36k.
Data is compressed from the bigger buffer to registered buffer which is
returned to backends.
Pstore will indicate that with a flag 'compressed' which is passed to backends.
Using this flag, backends will add a flag in their header to indicate the data
is compressed or not while writing to persistent store.


The significant compression that I have mentioned had repeated occurrences in the
text. When I tried with plain text I saw compression of around 45% with compression
parameters I have used.

If the record size is fixed across all the backends then it would be easy to come
up with a pre defined set of compression parameters as well as the buffer size of
compressed/decompressed data based on experiments. In power as of now, the maximum size
of the record is 4k. So compression support on power was provided with multiply (100/45)
considering the maximum record size to be 4k.

How is it with erst and efivars?

- Aruna

> -Tony
>

