Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbaEaIsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 04:48:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53117 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbaEaIsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 04:48:02 -0400
Message-ID: <53899717.1050109@zytor.com>
Date: Sat, 31 May 2014 01:47:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC 06/32] isofs: fix timestamps beyond 2027
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>	<1401480116-1973111-7-git-send-email-arnd@arndb.de> <CAMuHMdXn2wzhU6f-qVsFAoVZQOciRbi8ZBdjQpHQf96qRC2kww@mail.gmail.com>
In-Reply-To: <CAMuHMdXn2wzhU6f-qVsFAoVZQOciRbi8ZBdjQpHQf96qRC2kww@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2014 12:59 AM, Geert Uytterhoeven wrote:
> On Fri, May 30, 2014 at 10:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> isofs uses a 'char' variable to load the number of years since
>> 1900 for an inode timestamp. On architectures that use a signed
>> char type by default, this results in an invalid date for
>> anything beyond 2027.
>>
>> This adds a cast to 'u8' for the year number, which should extend
>> the shelf life of the file system until 2155.
> 
> Oops, the CD archive of my scanned Napoleon manuscripts no longer has the
> right file date? ;-)
> 
> Are there any practical uses of representating dates between 1772 and 1900
> on CD/DVD?
> 

Unlikely, furthermore, the spec explicitly states that the number is
unsigned (ref: ECMA-119, 2nd ed, 9.1.5 which specifies that the numbers
are "recorded according to 7.1.1"; 7.1.1 specifies "8-bit unsigned
numerical values").

	-hpa


