Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaKSOYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:24:30 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:40860 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaKSOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:24:29 -0500
Date: Wed, 19 Nov 2014 09:24:28 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1188484563.12277918.1416407068678.JavaMail.zimbra@redhat.com>
In-Reply-To: <1199595966.12277152.1416407044657.JavaMail.zimbra@redhat.com>
Subject: Re: crash/gdb: DW_FORM_strp pointing outside of .debug_str section
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF22 (Linux)/8.0.6_GA_5922)
Thread-Topic: crash/gdb: DW_FORM_strp pointing outside of .debug_str section
Thread-Index: 9yF9Y8aMRKNsqFoPdMcMsZ051vqOig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
>     I have been trying to debug a multi controller hang issue with crash.
> 
> It seems that crash works fine on stock ubuntu 14.04 running
> 3.13.0-39-generic. However when I recompile kernel and try to run
> crash on it I get the following error:
> 
> crash> mod -s nvme ./nvme.ko
>      MODULE       NAME                    SIZE  OBJECT FILE
> ffffffffa01d1240  nvme                   58727  ./nvme.ko
> crash> add-symbol-file ./nvme.ko 0xffffffffa01d1240
> add symbol table from file "./nvme.ko" at
>         .text_addr = 0xffffffffa01d1240
> Reading symbols from /root/mynvme.sriov/nvme.ko...DW_FORM_strp
> pointing outside of .debug_str section [in module
> /root/mynvme.sriov/nvme.ko]
> gdb: gdb request failed: add-symbol-file ./nvme.ko 0xffffffffa01d1240
> crash>
> Any input on what I might have done wrong? Do I need to rebuild the
> crash utility package along with the kernel?
> 
> Thanks,
> Kallol
 
This is the wrong mailing list for crash utility issues.  Please send
your queries to crash-utility@redhat.com.

That being said, the "mod -s" command does the add-symbol-file command
behind the scenes.  Your discrete "add-symbol-file" command is both
unnecessary and incorrect -- 0xffffffffa01d1240 is the address
of the nvme module's module data structure and not the starting
text address.

Dave Anderson
