Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577Ab3DCPlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:41:23 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:46937 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760450Ab3DCPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:41:22 -0400
X-Authority-Analysis: v=2.0 cv=cYNQXw/M c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=z55uD49gxukA:10 a=COy8bEXE5_QA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=p-BZX3ACu3QA:10 a=QfKxxUxMAAAA:8 a=Ifx0Yg7Le1XTJ8Na8y0A:9 a=wPNLvfGTeEIA:10 a=p2QX66BWMCoQJul2:21 a=EQP6CXc1MalLaWHl:21 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <515C4D9D.10103@ubuntu.com>
Date: Wed, 03 Apr 2013 11:41:17 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: CAI Qian <caiqian@redhat.com>, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com> <247719576.438259.1364882929749.JavaMail.root@redhat.com> <20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk> <20130402073035.GD3670@kernel.dk> <14055702.547701.1364891947331.JavaMail.root@redhat.com> <20130402090047.GF3670@kernel.dk> <985125161.581860.1364895066584.JavaMail.root@redhat.com> <20130402094834.GA4667@kernel.dk> <20130403114142.GP4667@kernel.dk>
In-Reply-To: <20130403114142.GP4667@kernel.dk>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/3/2013 7:41 AM, Jens Axboe wrote:
>> Thanks for testing! I don't particularly like this stuff in
>> loop, though. It's quite nasty and depends on other behaviour. It
>> would be prettier if we just had rescan_partitions() do the right
>> thing, and only drop partitions and not rescan if NO_PART_SCAN is
>> set.
>> 
>> Ala the below, dropping the loop change and implementing that
>> change in the core code. Phillip, can you check whether this does
>> the right thing for your bug too?
> 
> Phillip? I'm going to revert the loop change asap, so if you want
> this fixed for 3.10, it's about that time to test it out.

I have not tested it yet, but I am pretty sure it won't work.  It
looks like the patch changes the BLKRRPART path to go ahead and remove
existing partitions when GENHD_FL_NO_PARTSCAN is set.  loop doesn't
issue the BLKRRPART ioctl when !LO_FLAGS_PARTSCAN so this won't help.
 I think loop needs to set GENHD_FL_NO_PARTSCAN and then issue the
ioctl regardless of the LO_FLAGS_PARTSCAN flag to get the partitions
to be removed.  I will try to test tonight.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRXE2dAAoJEJrBOlT6nu75PM0IAIxVmuHdxLPtdtUNPqkU2a1r
QanHb6F43qSbd7l37XlwYgzUlybVlntf1yvKGzh29g3QM0603sFqV1o+mbXd5LI3
b+I5QrQJh90Vou9oVSAxz1Ps/AlZvxVIDv8bRwNhpXcMmaj0EN5R+6pU5L7KU2BU
GFsvajssedFh3XnNskgkR3XlqevI7U7A8VqLRsswl7FJVu7R1s45xP/sQgBWgiUS
P5viykwhje4OTKmu0D7bFKrOVx6O3gK7IHzdOwwT9aWRxuxL+Y9yfBF9nx/xZXkc
I2G09w852KgYDVYUHgW3IfuRo4F+4Y7Mw0Klu4XX5OmEXhselIqhwwTmEKMvEns=
=OLri
-----END PGP SIGNATURE-----
