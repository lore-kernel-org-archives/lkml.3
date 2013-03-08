Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343Ab3CHDzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:55:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab3CHDzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:55:33 -0500
Message-ID: <51396132.1030007@redhat.com>
Date: Fri, 08 Mar 2013 11:55:30 +0800
From: WANG Chao <chaowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: vmlinux symtab matching kallsyms fails: diff end addr for aesni_gcm_dec/aesni_gcm_enc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

On 3.9-rc1, I got following failure running `perf test`:

 1: vmlinux symtab matches kallsyms:
--- start ---
Looking at the vmlinux_path (6 entries long)
Using /lib/modules/3.9.0-rc1/build/vmlinux for symbols
0xffffffff810508b0: diff end addr for aesni_gcm_dec v:
0xffffffff81053551 k: 0xffffffff81050941
0xffffffff81053560: diff end addr for aesni_gcm_enc v:
0xffffffff8105619a k: 0xffffffff810535f1
Maps only in vmlinux:
 ffffffff81a311f5-ffffffff81b8c48f 0 [kernel].init.text
 ffffffff81b8c490-ffffffff9fffffff 0 [kernel].exit.text
Maps in vmlinux with a different name in kallsyms:
Maps only in kallsyms:
---- end ----
vmlinux symtab matches kallsyms: FAILED!

The end addr of aesni_gcm_dec/aesni_gcm_enc in vmlinux symtab and
kallsyms is wrong beyond 4K.

I think that's a problem or am I missing some changes for these days?

-- 
Thanks,
WANG Chao
