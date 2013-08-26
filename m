Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3HZOTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:19:38 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:38886 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3HZOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:19:36 -0400
Message-ID: <521B63F7.9050409@linux.vnet.ibm.com>
Date: Mon, 26 Aug 2013 16:19:35 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: "LF.Tan" <lftan.linux@gmail.com>
CC: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        Christophe Guillon <christophe.guillon@st.com>, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: Re: [RFC PATCH 0/4] add support for gcov format introduced in gcc
 4.7
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com> <52177AD7.1030709@linux.vnet.ibm.com> <20130823161532.GA2336@localhost.localdomain> <CAFiDJ5_S9Y_9t4kmkh5a9vK8bZFf1ZispTiWxj7PybxJpvYZ3w@mail.gmail.com>
In-Reply-To: <CAFiDJ5_S9Y_9t4kmkh5a9vK8bZFf1ZispTiWxj7PybxJpvYZ3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082614-0542-0000-0000-0000063E6C7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.2013 13:39, LF.Tan wrote:
> Hi all
> 
> I am interested to enable Gcov on my platform (on a target board). I
> have tried to apply the 4 patches submitted by Frantisek Hrbata. But,
> the *.gcda is always empty. Note, I am using GCC 4.7.3.
> 
> I have followed the steps in Documentation/gcov.txt. I've mounted the
> NFS filesystem and it has access to the kernel build directory on host
> machine.The path for the kernel source in host and target are same.
> 
> Let said my kernel module is under drivers/misc,
> drivers/misc/module.ko. Turn on Gcov in drivers/misc/Makefile.
> 
> 1. mount -t debugfs none /sys/kernel/debug/
> 2. insmod <PATH>/module.ko
> 3. Perform some actions to excute code in module.ko
> 4. rmmod <PATH>/module.ko
> 5. Check /sys/kernel/debug/gcov/<PATH>/drivers/misc/. There is a soft
> link of module.gcno (I check the soft link is working), but
> module.gcda is empty.

Are you sure they are empty? .gcda files report a file size of 0 as many
virtual files do, but you can read data from them nevertheless. You could
try running "cat" on them to copy their contents for example.

> Any step is incorrect or missing? Or anyone know how to enable GCOV on
> target board? Please advice.
> I would like to enable GCOV in arch/ code as well.
> Thank you very much.

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

