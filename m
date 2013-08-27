Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3H0Cif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 22:38:35 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:39061 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3H0Cid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 22:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <521B63F7.9050409@linux.vnet.ibm.com>
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com>
	<52177AD7.1030709@linux.vnet.ibm.com>
	<20130823161532.GA2336@localhost.localdomain>
	<CAFiDJ5_S9Y_9t4kmkh5a9vK8bZFf1ZispTiWxj7PybxJpvYZ3w@mail.gmail.com>
	<521B63F7.9050409@linux.vnet.ibm.com>
Date: Tue, 27 Aug 2013 10:38:32 +0800
Message-ID: <CAFiDJ5_buV4TK3wd7Nk62++mtwMAnEa2Xar0ZpRZmQ3RY9LO+g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] add support for gcov format introduced in gcc 4.7
From: "LF.Tan" <lftan.linux@gmail.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        Christophe Guillon <christophe.guillon@st.com>, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        mgahagan@redhat.com, agospoda@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter

I can get the gcda for the kernel loadable module now. Yes, the
virtual file is with size 0 and I saw the file is empty with 'vi'
command. But, it has data with 'cat' or 'hexdump' command.

Thanks.

On Mon, Aug 26, 2013 at 10:19 PM, Peter Oberparleiter
<oberpar@linux.vnet.ibm.com> wrote:
> On 26.08.2013 13:39, LF.Tan wrote:
>> Hi all
>>
>> I am interested to enable Gcov on my platform (on a target board). I
>> have tried to apply the 4 patches submitted by Frantisek Hrbata. But,
>> the *.gcda is always empty. Note, I am using GCC 4.7.3.
>>
>> I have followed the steps in Documentation/gcov.txt. I've mounted the
>> NFS filesystem and it has access to the kernel build directory on host
>> machine.The path for the kernel source in host and target are same.
>>
>> Let said my kernel module is under drivers/misc,
>> drivers/misc/module.ko. Turn on Gcov in drivers/misc/Makefile.
>>
>> 1. mount -t debugfs none /sys/kernel/debug/
>> 2. insmod <PATH>/module.ko
>> 3. Perform some actions to excute code in module.ko
>> 4. rmmod <PATH>/module.ko
>> 5. Check /sys/kernel/debug/gcov/<PATH>/drivers/misc/. There is a soft
>> link of module.gcno (I check the soft link is working), but
>> module.gcda is empty.
>
> Are you sure they are empty? .gcda files report a file size of 0 as many
> virtual files do, but you can read data from them nevertheless. You could
> try running "cat" on them to copy their contents for example.
>
>> Any step is incorrect or missing? Or anyone know how to enable GCOV on
>> target board? Please advice.
>> I would like to enable GCOV in arch/ code as well.
>> Thank you very much.
>
> --
> Peter Oberparleiter
> Linux on System z Development - IBM Germany
>
