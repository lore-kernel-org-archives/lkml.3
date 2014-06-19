Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbaFSQYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:24:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14192 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757494AbaFSQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:24:17 -0400
Message-ID: <53A30EAA.1010504@fb.com>
Date: Thu, 19 Jun 2014 09:24:10 -0700
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <daniel@phunq.net>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <tux3@tux3.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
References: <5376B273.7000800@partner.samsung.com>
In-Reply-To: <5376B273.7000800@partner.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-19_04:2014-06-19,2014-06-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.997600857122248 urlsuspect_oldscore=0.997600857122248
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406190196
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/16/2014 05:50 PM, Daniel Phillips wrote:
> We would like to offer Tux3 for review for mainline merge. We have prepared a new repository suitable for pulling:
>
> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=HU1zkg6rNOpSE0e5%2FKr7FH%2B2v8AbariYTtSijfNFsCY%3D%0A&s=941c4856b064898f9f05c0337b06db718dab951d8e65fccffaced7bd1d5e91a2
>
> Tux3 kernel module files are here:
>
> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=HU1zkg6rNOpSE0e5%2FKr7FH%2B2v8AbariYTtSijfNFsCY%3D%0A&s=2471ce8b7706ede604604a5be7130daeb9424b7197122a66491c365525fbabe1
>
> Tux3 userspace tools and tests are here:
>
> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3/user?h%3Duser&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=HU1zkg6rNOpSE0e5%2FKr7FH%2B2v8AbariYTtSijfNFsCY%3D%0A&s=5b2ed7f8f99d030c502fd74e47c18ca75e5889f6bc4e5b45f5dd9031fe853ac2
>
> Repository
>
> We are moving our development to the kernel.org tree from our standalone Github repository. Our history was imported from the standalone repository using git am. Our kernel.org tree is the usual fork of Linus mainline, with Tux3 kernel files on the master branch and userspace files in fs/tux3/user on the user branch. We maintain the user files in our kernel tree because Tux3 has a tighter coupling than usual between userspace and kernel.
>
> Most of our kernel code also runs in userspace, for testing or as a fuse filesystem or as part of our userspace support. We also need to keep our master branch clean of userspace files. These conflicting requirements creates challenges for our workflow. We can't just merge from user to master because that would pull in userspace files to kernel, and we can't merge from master to user because that would pull the entire kernel history into our branch. The best idea we have come up with is to cherry-pick changes from user to master and master to user. This creates merge noise in our user history and requires care to avoid combining kernel and userspace changes in the same commit. At least, this is better than having two completely separate repositories. Probably. We would appreciate any comment on how this workflow could be improved.
>
> For the time being, the subtree at fs/tux3 can also be used standalone. Run make in fs/tux3 to build a kernel module for the running kernel version. Run make in fs/tux3/user to build userspace commands including "tux3 mkfs". Run "make tests" in fs/tux3/user to run our unit tests. This capability might be useful for people interested in experimenting with Tux3 in user space, and is handy for a quick build of the user support without needing to pull the whole repository.
>
> The tux3 command built in fs/tux3/user provides our support tools including "tux3 mkfs" and "tux3 fsck". For now, we do not build a standalone mkfs.tux3 and consider that a feature, not a bug, because it sends the message that Tux3 is for developers right now.
>
> API changes
>
> Tux3 does not implement any custom or extended interfaces.
>
> Core changes
>
> Tux3 builds without any core changes, however we do some unnatural things to enable that. We would like to have some core changes to clean this up. One is a correctness issue for mmap and three others are to clean up ugly workarounds. Without any core changes, mmap will be disabled because there is a potential for stale cache pages with combined file and mmap IO. I will describe them here and provide patches if asked:
>

So I'd really like to see the page fork stuff broken out in their own core
change.  I want to do something like this to get around the stable pages pain
but haven't had the time to look at it, so if we can hammer out what you guys
did into something workable and generic that would be great.  Thanks,

Josef
