Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaJCNHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:07:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33750 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaJCNHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:07:17 -0400
Message-ID: <542E9F82.20709@6wind.com>
Date: Fri, 03 Oct 2014 15:07:14 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, rui.xiang@huawei.com,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, kirill.shutemov@linux.intel.com,
        Grant Likely <grant.likely@secretlab.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Thierry Herbelot <thierry.herbelot@6wind.com>
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the directory
 entries
References: <20131003.150947.2179820478039260398.davem@davemloft.net>	<1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>	<1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com> <CACVxJT98EJvw1E+o6mpu8ugMz3Ztqz7pJOwZeZW9A41P0AhB_g@mail.gmail.com>
In-Reply-To: <CACVxJT98EJvw1E+o6mpu8ugMz3Ztqz7pJOwZeZW9A41P0AhB_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03/10/2014 12:55, Alexey Dobriyan a écrit :
> On Thu, Oct 2, 2014 at 6:25 PM, Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> --- a/fs/proc/generic.c
>> +++ b/fs/proc/generic.c
>> @@ -81,10 +81,13 @@ static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
>
>> +       if (!S_ISDIR(de->mode))
>> +               return -EINVAL;
>
> There are way too many S_ISDIR checks.
> In lookup and readdir, it is guaranteed that PDE is directory.
>
> I'd say all of them aren't needed because non-directories have
> ->subdir = NULL and
> directories have ->subdir != NULL which transforms into hashtable or
> rbtree or whatever,
> so you only need to guarantee only directories appear where they are
> expected and
> fearlessly use your new data structure traversing directories.
To be honest, they was put during the debug stage and I hesitated to remove
them at the end.
I will remove them!


Thank you,
Nicolas
