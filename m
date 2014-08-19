Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaHSPpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:45:16 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34274 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHSPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:45:13 -0400
Message-ID: <53F37105.1000200@suse.cz>
Date: Tue, 19 Aug 2014 17:45:09 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Kamal Mostafa <kamal@canonical.com>
CC: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.8 107/116] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
References: <1406067727-19683-1-git-send-email-kamal@canonical.com> <1406067727-19683-108-git-send-email-kamal@canonical.com> <alpine.LSU.2.11.1407221608040.3128@eggly.anvils> <1406149325.3612.33.camel@fourier> <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1407231659330.2093@eggly.anvils>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/24/2014, 02:07 AM, Hugh Dickins wrote:
> On Wed, 23 Jul 2014, Kamal Mostafa wrote:
>> On Tue, 2014-07-22 at 16:08 -0700, Hugh Dickins wrote:
>>> On Tue, 22 Jul 2014, Kamal Mostafa wrote:
>>> 
>>>> 3.8.13.27 -stable review patch.  If anyone has any
>>>> objections, please let me know.
>>>> 
>>>> ------------------
>>>> 
>>>> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>>>> 
>>>> commit 4a705fef986231a3e7a6b1a6d3c37025f021f49f upstream.
>>>> 
>>>> There's a race between fork() and hugepage migration, as a
>>>> result we try [...]
>>> 
>>> Please drop this one for now: other -stables have carried it,
>>> but it was found last week to contain a bug of its own,
>>> arguably worse than what it's fixing.  Naoya-san has done the
>>> fix for that, it's in mmotm and should make its way to Linus
>>> probably this week: so please hold this back until that can
>>> join it - thanks.
>>> 
>>> Hugh
>> 
>> OK, I've dropped it from the 3.8-stable queue, and will watch for
>> the fix to land.  Thanks very much, Hugh!
> 
> commit 0253d634e0803a8376a0d88efee0bf523d8673f9 Author: Naoya
> Horiguchi <n-horiguchi@ah.jp.nec.com> Date:   Wed Jul 23 14:00:19
> 2014 -0700 mm: hugetlb: fix copy_hugetlb_page_range()
> 
> is now in Linus's tree: so the original patch is good to go into 
> your -stables, so long as you add 0253d634e080 on top.

So I have queued both to 3.12 now. Thanks.

- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT83EFAAoJEL0lsQQGtHBJMfAP/jkMSZK9NI6ApH7RB+YREGgI
l3+0qdjYsknE/RlC7exmSh3WY+EfMc4iPcBomiQ3n26FTCEYo00xeqjSXLXcdVIK
AtUawzDRuQvKHBDFZvqgtBVpHRT89WkqoMSchzBDeFx3M6XvLWW2waUoI0aPu4s+
PYc2cqlgz2lAP9u8Ic1qNu3vznbWt+p96/H9b4wb3/UE9IxU1PCfkvq66ep9w2cv
0vq6VqszQwCQsP0Jb75b2EV+1woqCvlz6pOcf3qZlpkzLwcZ3UQHDha0USwMAHMa
L354ZxdKbyqZJrYwH6PDWWIEkMQ5mULHoesHjZg7oVIAsE3kJsqAghf6o+tK9Li7
RqXy2SxhV2/08AAk8QzAuJGKZp4rtZFc0O5eB6V9JWag2+5xLV5EmSWstkQAbGNc
IkVmGZuZWsiaIDj/eTOD4+p7iU51nj4GPxKEe/S51B7iFAjwenczIaSDFqDcLxU7
HiSDGxRMb16TQtBgX9v+sZDDlhf/y4gG9dUYNgAhteQklriXfaF6fiH5MhsCUmNW
tOIiyQV6NQ2XXCzZvGvGVBHutxKNQhQQtiiTMamp5U1sLcg9iAjyFemRK49W+Q3q
5gumMp+1ObY0XgqjRA6b7zVYYqIMtrLVTlWvTVB+UsQ9cS8stYfC0EYgSD/thvZ6
k3x6oxbVkZMrZDJCHWMP
=72iL
-----END PGP SIGNATURE-----
