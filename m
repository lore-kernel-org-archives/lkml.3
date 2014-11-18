Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbaKRXIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:08:51 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:54872 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbaKRXIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:08:50 -0500
MIME-Version: 1.0
Date: Tue, 18 Nov 2014 15:08:49 -0800
Message-ID: <CA+QbAV5q2U2uueD9mW9hXyTLipmKeA1uUC_DntJzxZ73ieyxRA@mail.gmail.com>
Subject: crash/gdb: DW_FORM_strp pointing outside of .debug_str section
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I have been trying to debug a multi controller hang issue with crash.

It seems that crash works fine on stock ubuntu 14.04 running
3.13.0-39-generic. However when I recompile kernel and try to run
crash on it I get the following error:

crash> mod -s nvme ./nvme.ko
     MODULE       NAME                    SIZE  OBJECT FILE
ffffffffa01d1240  nvme                   58727  ./nvme.ko
crash> add-symbol-file ./nvme.ko 0xffffffffa01d1240
add symbol table from file "./nvme.ko" at
        .text_addr = 0xffffffffa01d1240
Reading symbols from /root/mynvme.sriov/nvme.ko...DW_FORM_strp
pointing outside of .debug_str section [in module
/root/mynvme.sriov/nvme.ko]
gdb: gdb request failed: add-symbol-file ./nvme.ko 0xffffffffa01d1240
crash>

Any input on what I might have done wrong? Do I need to rebuild the
crash utility package along with the kernel?

Thanks,
Kallol
