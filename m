Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbbA1U7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:59:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbbA1U7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:59:05 -0500
Message-ID: <54C8D7B0.7030803@redhat.com>
Date: Wed, 28 Jan 2015 07:36:00 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
CC: John Moser <john.r.moser@gmail.com>, linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: OOM at low page cache?
References: <54C2C89C.8080002@gmail.com> <54C77086.7090505@suse.cz> <20150128062609.GA4706@blaptop>
In-Reply-To: <20150128062609.GA4706@blaptop>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/28/2015 01:26 AM, Minchan Kim wrote:
> Hello,
> 
> On Tue, Jan 27, 2015 at 12:03:34PM +0100, Vlastimil Babka wrote:
>> CC linux-mm in case somebody has a good answer but missed this in
>> lkml traffic
>> 
>> On 01/23/2015 11:18 PM, John Moser wrote:
>>> Why is there no tunable to OOM at low page cache?
> 
> AFAIR, there were several trial although there wasn't acceptable at
> that time. One thing I can remember is min_filelist_kbytes. FYI,
> http://lwn.net/Articles/412313/

The Android low memory killer does exactly what you want, and
for very much the same reasons.

See drivers/staging/android/lowmemorykiller.c

However, in the mainline kernel I think it does make sense to
apply something like the patch that Minchan cooked up with, to OOM
if freeing all the page cache could not bring us back up to the high
watermark, across all the memory zones.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUyNewAAoJEM553pKExN6DlKQH/3PprrXF7IOyjiXnO+2Qqbau
wgWXO7mQWGFi+zNqSUzmWtfTCFVx6BxLi23MCQG1RqKGnQI4DehdOKMDidFwoC8D
2grKe9ELp04mEbyG0aipdxSw6FouIDFhC2FzmU7oQDZX5RKmLuxY7QPU4NTCitcR
xHp6jWrvyY2CDiSpA2QSAaAAIG21BtPJvXQg3WvY/LI03N1edqZnExt5Po8CY7oe
EeiO7ZtYISl/wRIoribEafZF4rMAfJ5A36kdbulqCqVtgCWEDPV0RCXimc5EtDIt
bFDiv924+YMiuEFULJlEqLGqTJOtfJ+NlBIn8nVRk5P1pOGEbO05zE+XV1Vea6k=
=8351
-----END PGP SIGNATURE-----
