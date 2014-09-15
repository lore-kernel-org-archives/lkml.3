Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaIOHsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:48:45 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:43976 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaIOHsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:48:43 -0400
Message-ID: <541697EA.6040909@suse.cz>
Date: Mon, 15 Sep 2014 09:40:26 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 3.12 40/56] ext4: fix ext4_discard_allocated_blocks()
 if we can't allocate the pa struct
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>	 <9f48c2853290b15ecdcd9ba83b41eaab63f22682.1409735865.git.jslaby@suse.cz> <1410749203.3040.57.camel@decadent.org.uk>
In-Reply-To: <1410749203.3040.57.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/15/2014, 04:46 AM, Ben Hutchings wrote:
> On Wed, 2014-09-03 at 11:26 +0200, Jiri Slaby wrote:
>> From: Theodore Ts'o <tytso@mit.edu>
>> 
>> 3.12-stable review patch.  If anyone has any objections, please
>> let me know.
>> 
>> ===============
>> 
>> commit 86f0afd463215fc3e58020493482faa4ac3a4d69 upstream.
>> 
>> If there is a failure while allocating the preallocation
>> structure, a number of blocks can end up getting marked in the
>> in-memory buddy bitmap, and then not getting released.  This can
>> result in the following corruption getting reported by the
>> kernel:
>> 
>> EXT4-fs error (device sda3): ext4_mb_generate_buddy:758: group
>> 1126, 12793 clusters in bitmap, 12729 in gd
>> 
>> In that case, we need to release the blocks using
>> mb_free_blocks().
>> 
>> Tested: fs smoke test; also demonstrated that with injected
>> errors, the file system is no longer getting corrupted
>> 
>> Google-Bug-Id: 16657874
>> 
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu> Signed-off-by:
>> Jiri Slaby <jslaby@suse.cz>
> [...]
> 
> It's a bit late now, but Ted said this introduced a regression
> that's fixed by commit c99d1e6e83b0 ("ext4: fix BUG_ON in
> mb_free_blocks()").

Oh, now queued for 3.12. Thanks!

- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUFpfqAAoJEL0lsQQGtHBJOBsP/2sJ9vMgzDwOLpA5VTxJLUUP
9D4Jn6F4Z2TVR+l0pwaHIKgWjnMA1WEEr/FL5WxOSyGq0Rx10pqeOmI8U6wFq/K8
dhmFQfV5WZxYzCzB9ozae3fwzt7ap0V7yINXq7AkLIfZA1uhB/L5xuX7ZMuqM7ec
h4/+ylkLuhQg8LrF43+S8PQNRvgLcn/4XsiCLwR1fvJYFgcz6/i2uiBlG8eS5F0k
WKL/Rg/B66DrLD+RloJnvpshGJY8XGEqu2wx+a/QNiDV2n9aKWzDNcjX0Y+YEsdd
8Or9J5h018BgB3ktNJB4sd85mkrjhrzTkCyNQoKBc3NjqeJv2Eei1rB4Ds1oLiaH
wjgWRXNhYC3h5ifDBazEtAu7fH2fWuMeaAtX+t/4r1DitW9H0FpRNy28lYbYzoV/
HMKAhUCePdWe96TWcbiL7GovbagdcD8HqOqQpYLX9SWb8uEQFKzYCCFNvgFe489o
R89uARU49K6EQRFr9rj36YyQm/OkPpiJByrEGcbEMTYiQb6FiNkKsV2iznXHJ75y
kfTje9K6RpKRl0RSaQUK7F7+rP+IH+ajtJD5Umw1eWQ4y+kGQg9RT9Z12SCBpHjF
s0hkIZp71loIWqlS45+EPCez/Yr0szmqyvZthz87hGL1BlXmwN8tyzhdSkpe1bFy
cBVtTov4saNk84Z72Foe
=egHB
-----END PGP SIGNATURE-----
