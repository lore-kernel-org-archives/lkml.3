Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab3CIBWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 20:22:23 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:42926 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3CIBWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 20:22:21 -0500
X-Authority-Analysis: v=2.0 cv=cYNQXw/M c=1 sm=0 a=C56BoFkcj+OI1kjAe8jE5A==:17 a=MtVMNMWb1ewA:10 a=mBswGg73kkcA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=VrFzeNeFecIA:10 a=QfKxxUxMAAAA:8 a=ULGdlB65cfvei5oWAMAA:9 a=wPNLvfGTeEIA:10 a=C56BoFkcj+OI1kjAe8jE5A==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 142.196.87.46
Message-ID: <513A8ECB.8000504@ubuntu.com>
Date: Fri, 08 Mar 2013 20:22:19 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org> <5139975F.9070509@symas.com> <20130308084246.GA4411@shutemov.name> <5139B214.3040303@symas.com> <5139FA13.8090305@genband.com> <5139FD27.1030208@symas.com>
In-Reply-To: <5139FD27.1030208@symas.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/08/2013 10:00 AM, Howard Chu wrote:
> Yes, that's what I was thinking. I added a 
> posix_madvise(..POSIX_MADV_RANDOM) but that had no effect on the
> test.

Yep, that's because it isn't implemented.

You might try MADV_WILLNEED to schedule it to be read in first.  I
believe that will only read in the requested page, without additional
readahead, and then when you fault on the page, it already has IO
scheduled, so the extra readahead will also be skipped.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQEcBAEBAgAGBQJROo7GAAoJEJrBOlT6nu759SAH+wRhoUIZUuzNGrhfUJ6RnwV8
VjFyftBCAsdC+Mzq81Da3KJOi+BdYV8VbkYNPzbKll5AnxzL5Udvbdyf9SkROhug
UgLWHe8pC6ZtHfSvWBCqS1YDLkzw+TiWwJzuL5iUEDC2NGuUJQ5SbhwyTEypvWai
pdPZeFVyhLAKOtAUwD5e/5vhBWSq2M1TG2C7BUCow2fbJ6kil+kWuXtiDeNPvtUk
4FwabL8zHA9pNtMlHB0cUrn5W3VQYGqeTaDngjyLxR1gw7uFQn52G47IPe2LAMGx
58L/tHjbkSY9oukGiMHoF1jiaFqJqV1pw+Q2P7S+0XsU8JdW6CmzotTqDmcozqE=
=DOZT
-----END PGP SIGNATURE-----
