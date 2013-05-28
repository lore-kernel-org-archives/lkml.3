Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab3E1OvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:51:07 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:36837 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934374Ab3E1OvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:51:05 -0400
X-Authority-Analysis: v=2.0 cv=JqNzXbEC c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=bfzWQn4VrGAA:10 a=COy8bEXE5_QA:10 a=S1A5HrydsesA:10 a=N659UExz7-8A:10 a=fxJcL_dCAAAA:8 a=p-BZX3ACu3QA:10 a=QfKxxUxMAAAA:8 a=m5ll2mmbexfkeFbRm1QA:9 a=pILNOxqGKmIA:10 a=4t1vQi-YglNiGWNj:21 a=iG7ObV0x8g7S0wWv:21 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <51A4C456.6000708@ubuntu.com>
Date: Tue, 28 May 2013 10:51:02 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: CAI Qian <caiqian@redhat.com>, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com> <247719576.438259.1364882929749.JavaMail.root@redhat.com> <20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk> <20130402073035.GD3670@kernel.dk> <14055702.547701.1364891947331.JavaMail.root@redhat.com> <20130402090047.GF3670@kernel.dk> <985125161.581860.1364895066584.JavaMail.root@redhat.com> <20130402094834.GA4667@kernel.dk> <20130403114142.GP4667@kernel.dk> <515C4D9D.10103@ubuntu.com> <515DE2FE.1080201@ubuntu.com>
In-Reply-To: <515DE2FE.1080201@ubuntu.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Jens, did this get lost in the shuffle, or just miss the window for
3.10 and will go in 3.11?

On 4/4/2013 4:30 PM, Phillip Susi wrote:
>> I have not tested it yet, but I am pretty sure it won't work.
>> It looks like the patch changes the BLKRRPART path to go ahead
>> and remove existing partitions when GENHD_FL_NO_PARTSCAN is set.
>> loop doesn't issue the BLKRRPART ioctl when !LO_FLAGS_PARTSCAN so
>> this won't help. I think loop needs to set GENHD_FL_NO_PARTSCAN
>> and then issue the ioctl regardless of the LO_FLAGS_PARTSCAN flag
>> to get the partitions to be removed.  I will try to test
>> tonight.
> 
> After testing, my initial thoughts appeared to have been correct.
> I had to modify the patch as follows.  To test, simply do:
> 
> truncate -s 10m img losetup /dev/loop0 img parted /dev/loop0 
> mklabel msdos mkpart primary ext2 1m 2m quit ls /dev/loop0*
> 
> Note the /dev/loop0p1 node.  Run losetup -d /dev/loop0 and see if
> it is still there.
> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRpMRWAAoJEJrBOlT6nu75yUYH/1PSNmTOBYgvEqQclWPBTd8n
Fm95yILcIlJWdUr3gUvQmjBax1NzKnG3NZ2U4hucpCcJH4FkHSTTFl5uZ3wU1B/Q
nvuQoSqYXVP+V9PVSTsUsxOI4Mvw5YP5sFwSdwRKpkCldXOuHrRZsuccFtkQducU
AIij42jvI1un+/qc6NLW+/S+rcLGUj21boPmX3g80km1De9QMrYrbGAAEbFO3rrq
fzsvGuVvOroGppLGpze4iMDn060Lxrw6//KDGtiUBIeD8kZCFGkBh1KupHqLLzXm
gmfdlHIqAR5uWB29m9TOlRbHPzdeQutwt8zL2LOYlCft5OiBIOW8dT8EFkl2Buw=
=7BGq
-----END PGP SIGNATURE-----
