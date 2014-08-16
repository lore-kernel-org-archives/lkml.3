Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaHPPI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 11:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaHPPI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 11:08:26 -0400
Message-ID: <53EF73CB.6020404@redhat.com>
Date: Sat, 16 Aug 2014 11:07:55 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com
Subject: Re: [PATCH 2/3] time,signal: protect resource use statistics with
 seqlock
References: <1408133138-22048-1-git-send-email-riel@redhat.com> <1408133138-22048-3-git-send-email-riel@redhat.com> <20140816141159.GA8709@redhat.com>
In-Reply-To: <20140816141159.GA8709@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/16/2014 10:11 AM, Oleg Nesterov wrote:

>> +		/* +		 * If a writer is currently active, seq will be odd,
>> and +		 * read_seqbegin_or_lock will take the lock. +		 */ +
>> nextseq = raw_read_seqcount(&sig->stats_lock.seqcount); +	} while
>> (need_seqretry(&sig->stats_lock, seq)); +
>> done_seqretry(&sig->stats_lock, seq); rcu_read_unlock(); }
> 
> Rik, I do not understand why did you silently ignore my comments
> about this change twice ;)

I can explain why it appears that way.

I made the fix you suggested in one tree, and did my
"guilt patchbomb" from another tree.  Doh...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT73PLAAoJEM553pKExN6DPNcH/jWQ1qKSyW9rDOETjGAkau2r
KcVoeaqliqYhNi6IDDpqZb0LvOFp9jD+ykiwxGD4KjoNX3iR0pLE7ymm3mh/dH7q
0t3zI+640ydbd5WEcVkpPMT6C0pdPNuEM01iuM0YExWErLPbhFuGcgV7fUn1idTx
L//L9OQNImTxRPPYr+4OEGZh99CqnBG3PjoCtXoa4dvsqsrz2SQ/yUtfAlF4veVY
C6nLdt5zfehaRypzzufsYbyMjLm2uXufEuqibeJI0G2w/qB4Q0+80d+JytETB9Q3
R1VWDjQrLjrIPbMNVkXKK+Px/q7d5q+DPE+uB0lmpmcjIqBJjVhviw/wx9AhJc4=
=Gm8e
-----END PGP SIGNATURE-----
