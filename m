Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3JQM5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:57:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:63871 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3JQM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:57:51 -0400
From: Liuyongan <liuyongan@huawei.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Qianhuibin <qianhuibin@huawei.com>
Subject: kprobe pre_handler change return IP
Thread-Topic: kprobe pre_handler change return IP
Thread-Index: Ac7LOCsFLnDCNv9iRNWFSiq5It69WA==
Date: Thu, 17 Oct 2013 12:57:40 +0000
Message-ID: <E4ABEE53CC34664FA3F0BD8AEAF50A1941474DB1@szxeml511-mbs.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AZW9 Agxf BikP CZrq DMID Dv1x D1ic FtXD F6Ca GTEr Ghll
 GjGy HTd3 IYij IcX2
 KguX;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{885716E5-B803-4CD0-83C6-5D45E6C5B810};bABpAHUAeQBvAG4AZwBhAG4AQABoAHUAYQB3AGUAaQAuAGMAbwBtAA==;Thu,
 17 Oct 2013 12:55:37
 GMT;awBwAHIAbwBiAGUAIABwAHIAZQBfAGgAYQBuAGQAbABlAHIAIABjAGgAYQBuAGcAZQAgAHIAZQB0AHUAcgBuACAASQBQAA==
x-cr-puzzleid: {885716E5-B803-4CD0-83C6-5D45E6C5B810}
x-originating-ip: [10.135.68.95]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9HCvww0009451

I use kprobe to probe a function suppose: 
          int is_winter(int num) { ... }
          int replace_is_winter(int num) { ...} 
I want to replace is_winter() with replace_is_winter(), so when we call is_winter, replace_is_winter will be called.
                                                                                                                  
so:  
   int my_pre_handler(struct kprobe *p, struct pt_regs *regs)
   { 
        regs->ip = (unsigned long)&replace_is_winter;
        return 1;
   } 

and echo 0 > /proc/sys/debug/kprobes-optimization so that jump instruction will not be used.

I got a exception in fault_handler, and trap number is 14.

   fault_handler: p->addr = 0xffffffffa08e201a, ip = ffffffff8021c59d, trap #14n

Anyone here can help me ?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
