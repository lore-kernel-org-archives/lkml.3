Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbaGXSh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:37:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:51011 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603AbaGXSh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:37:56 -0400
Message-ID: <53D15280.5070407@gmx.de>
Date: Thu, 24 Jul 2014 20:37:52 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ilya Dryomov <ilya.dryomov@inktank.com>
CC: linux-ia64@vger.kernel.org, Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sizeof (struct tYpO *) : it is just a typo or rather a bug ?
References: <53D14E60.1010105@gmx.de> <CALFYKtAyB6xGEgJ65Ti5vPx9xf4ipX9__FZBwosBYg1y9z7cKg@mail.gmail.com>
In-Reply-To: <CALFYKtAyB6xGEgJ65Ti5vPx9xf4ipX9__FZBwosBYg1y9z7cKg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:c8Kjehwzin47qvzIbk0vXBNh74tx5tIpyfqvcydLanP3tsP75lL
 NLhyQBJDD28m+oQUFnuy5J3XSARf0Tg9V4KfP6+qnycu0LZszvmfp6kofCIy3FM2om+fqV8
 wcA3Xy9LWTXlzv+BEF1NwU+FnCAeeVfCrWvfwvd51BPRs5PW969Wp2IXBUZ+NOPuF70YwbV
 y6LbQHNxRkuJJOs8J8WKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 08:33 PM, Ilya Dryomov wrote:
> On Thu, Jul 24, 2014 at 10:20 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>> Inspired by this "typo" fix
>> http://article.gmane.org/gmane.linux.kernel/1754640
>> I grep'ed the current git tree of linus for similar issues.
>>
>> For these 4 places I'm wondering where the appropriate struct definition is located :
>>
>> arch/ia64/sn/kernel/io_acpi_init.c:         sizeof(struct pci_devdev_info *)) {
>> tools/perf/builtin-sched.c:     sched->tasks = realloc(sched->tasks, sched->nr_tasks * sizeof(struct task_task *));
>> fs/ceph/xattr.c:                xattrs = kcalloc(numattr, sizeof(struct ceph_xattr *),
>> fs/ceph/xattr.c:                memset(xattrs, 0, numattr*sizeof(struct ceph_xattr *));
> 
> Heh, the ceph one is a five year old typo..  Looks like it should be
> struct ceph_inode_xattr, I'll fix it up.  I'm curious though, how did
> you grep for these?
> 
> Thanks,
> 
>                 Ilya
> 

1:
	grep -Hr "sizeof[ *(]struct .* \*.)"  | cut -f2- -d':' | tee ~/tmp/out

2:
	cat ~/tmp/out | perl -wane 'chomp(); my ($left, $right) = split (/sizeof\(/); print $right, "\n";' | cut -f2 -d' ' | sort -u | cut -f1 -d')' | grep -v '^+' | while read i; do echo $i; git grep -q "struct $i {" || echo error; echo; done

3:
	ignore false positives

-- 
Toralf

