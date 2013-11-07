Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3KHACh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:02:37 -0500
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:51411 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab3KHAC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:02:29 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 19:02:29 EST
X-AuditID: 12074423-b7fac8e00000539e-11-527c28e81791
Date: Thu, 7 Nov 2013 18:57:25 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 00/11] random: code cleanups
Message-ID: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsUixG6nrvtCoybI4OZ6VYvdcxazWFzeNYfN
	gcnjzIIj7B6fN8kFMEVx2aSk5mSWpRbp2yVwZax9upm1oJmz4sBdxQbGJexdjJwcEgImEq8/
	7mWFsMUkLtxbz9bFyMUhJDCbSaJpxmYmCGcDo8TiUzehnJ+MEivnTGYDaWERUJHo3zMHbBSb
	gILEj/nrmEFsEQFliVUzNzGB2MwC9hK/p04GqxEW0JE4dXoKI4jNK2AgsfT5NXYIW1Di5Mwn
	LBD1WhI3/r0E6uUAsqUllv/jAAmLAq2acnIb2wRG/llIOmYh6ZiF0LGAkXkVo2xKbpVubmJm
	TnFqsm5xcmJeXmqRrplebmaJXmpK6SZGcCi6KO9g/HNQ6RCjAAejEg/viUvVQUKsiWXFlbmH
	GCU5mJREeSeq1wQJ8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuF9pgiU401JrKxKLcqHSUlzsCiJ
	897isA8SEkhPLEnNTk0tSC2CycpwcChJ8C4CGSpYlJqeWpGWmVOCkGbi4AQZzgM0fAlIDW9x
	QWJucWY6RP4Uo6KUOO8ckIQASCKjNA+uF5YqXjGKA70izLsKpIoHmGbgul8BDWYCGhzyqxJk
	cEkiQkqqgXGyjQ9bzOyMutIoq3WGleyO4Rm9Ch3XJPYHybn3LlnpvOnuX9sXunGZxrdrM15v
	Ols0QS161rl1brxcFyyLr9aeS+9km9J7J+9kapLR0fx4Fmse3/A306xW/Vl6n80td/Em4Y9y
	LZ49Wb5ZxzhfmNc79F0+pP4qRf9Uq+uFJYlGtySjJK5tUmIpzkg01GIuKk4EADYSw+zwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, hi all,

I recently read through the random number generator's code.
This series has fixes for some minor things I spotted.

Four of the patches touch comments only.  Four simplify code without
changing its behavior (total diffstat: 35 insertions, 73 deletions),
and one is a trivial signedness fix.  Two patches change the locking
and lockless concurrency control in account(), including one bugfix.
The bug is related to the one Jiri found and fixed in May.

Cheers,
Greg


Greg Price (11):
  random: fix typos / spelling errors in comments
  random: fix comment on proc_do_uuid
  random: fix description of get_random_bytes
  random: simplify loop in random_read
  random: declare trickle_count unsigned
  random: fix comment on "account"
  random: simplify accounting code slightly
  random: simplify accounting logic
  random: forget lock in lockless accounting
  random: pull 'min' check in accounting to inside lockless update
  random: simplify accounting code

 drivers/char/random.c | 164 ++++++++++++++++++++------------------------------
 1 file changed, 66 insertions(+), 98 deletions(-)

-- 
1.8.3.2
