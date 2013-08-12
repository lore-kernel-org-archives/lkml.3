Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3HLCqO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:46:14 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:48957 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755418Ab3HLCqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:46:10 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru 6C2CC7F574
Date: Mon, 12 Aug 2013 06:45:58 +0400
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kmemleak in apei_res_add
Message-ID: <20130812024556.GB29956@sanechka.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running 3.10.3 with kmemleak enabled, I see following warnings from
kmemleak:

unreferenced object 0xffff88024d2219a0 (size 32):
  comm "swapper/0", pid 1, jiffies 4294894532 (age 26865.180s)
  hex dump (first 32 bytes):
    58 de 0c 73 02 88 ff ff 58 de 0c 73 02 88 ff ff  X..s....X..s....
    18 50 fd 7d 00 00 00 00 3f 50 fd 7d 00 00 00 00  .P.}....?P.}....
  backtrace:
    [<ffffffff813ddf40>] kmemleak_alloc+0x21/0x3e
    [<ffffffff8111cb99>] kmemleak_alloc_recursive.constprop.58+0x16/0x18
    [<ffffffff8111efac>] kmem_cache_alloc_trace+0xe6/0x12f
    [<ffffffff81278f0e>] apei_res_add+0xb9/0xe8
    [<ffffffff81278faa>] collect_res_callback+0x6d/0x7c
    [<ffffffff812788ed>] apei_exec_for_each_entry+0x78/0x93
    [<ffffffff8127891d>] apei_exec_collect_resources+0x15/0x17
    [<ffffffff81b010e5>] erst_init+0x278/0x2a3
    [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
    [<ffffffff81ac9ee7>] kernel_init_freeable+0x13f/0x1cc
    [<ffffffff813db19f>] kernel_init+0x9/0xd6
    [<ffffffff813fe5bc>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88024d221980 (size 32):
  comm "swapper/0", pid 1, jiffies 4294894532 (age 26865.180s)
  hex dump (first 32 bytes):
    68 de 0c 73 02 88 ff ff 68 de 0c 73 02 88 ff ff  h..s....h..s....
    b2 00 00 00 00 00 00 00 b3 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff813ddf40>] kmemleak_alloc+0x21/0x3e
    [<ffffffff8111cb99>] kmemleak_alloc_recursive.constprop.58+0x16/0x18
    [<ffffffff8111efac>] kmem_cache_alloc_trace+0xe6/0x12f
    [<ffffffff81278f0e>] apei_res_add+0xb9/0xe8
    [<ffffffff81278faa>] collect_res_callback+0x6d/0x7c
    [<ffffffff812788ed>] apei_exec_for_each_entry+0x78/0x93
    [<ffffffff8127891d>] apei_exec_collect_resources+0x15/0x17
    [<ffffffff81b010e5>] erst_init+0x278/0x2a3
    [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
    [<ffffffff81ac9ee7>] kernel_init_freeable+0x13f/0x1cc
    [<ffffffff813db19f>] kernel_init+0x9/0xd6
    [<ffffffff813fe5bc>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88024d221960 (size 32):
  comm "swapper/0", pid 1, jiffies 4294894532 (age 26865.180s)
  hex dump (first 32 bytes):
    00 de 0c 73 02 88 ff ff 40 19 22 4d 02 88 ff ff  ...s....@."M....
    00 50 09 7e 00 00 00 00 00 90 29 7e 00 00 00 00  .P.~......)~....
  backtrace:
    [<ffffffff813ddf40>] kmemleak_alloc+0x21/0x3e
    [<ffffffff8111cb99>] kmemleak_alloc_recursive.constprop.58+0x16/0x18
    [<ffffffff8111efac>] kmem_cache_alloc_trace+0xe6/0x12f
    [<ffffffff81278f0e>] apei_res_add+0xb9/0xe8
    [<ffffffff81278fce>] apei_get_nvs_callback+0x15/0x17
    [<ffffffff8125197d>] acpi_nvs_for_each_region+0x25/0x46
    [<ffffffff8127903b>] apei_resources_request+0x56/0x217
    [<ffffffff81b00f28>] erst_init+0xbb/0x2a3
    [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
    [<ffffffff81ac9ee7>] kernel_init_freeable+0x13f/0x1cc
    [<ffffffff813db19f>] kernel_init+0x9/0xd6
    [<ffffffff813fe5bc>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88024d221940 (size 32):
  comm "swapper/0", pid 1, jiffies 4294894532 (age 26865.180s)
  hex dump (first 32 bytes):
    60 19 22 4d 02 88 ff ff 00 de 0c 73 02 88 ff ff  `."M.......s....
    00 00 37 7f 00 00 00 00 00 60 3f 7f 00 00 00 00  ..7......`?.....
  backtrace:
    [<ffffffff813ddf40>] kmemleak_alloc+0x21/0x3e
    [<ffffffff8111cb99>] kmemleak_alloc_recursive.constprop.58+0x16/0x18
    [<ffffffff8111efac>] kmem_cache_alloc_trace+0xe6/0x12f
    [<ffffffff81278f0e>] apei_res_add+0xb9/0xe8
    [<ffffffff81278fce>] apei_get_nvs_callback+0x15/0x17
    [<ffffffff8125197d>] acpi_nvs_for_each_region+0x25/0x46
    [<ffffffff8127903b>] apei_resources_request+0x56/0x217
    [<ffffffff81b00f28>] erst_init+0xbb/0x2a3
    [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
    [<ffffffff81ac9ee7>] kernel_init_freeable+0x13f/0x1cc
    [<ffffffff813db19f>] kernel_init+0x9/0xd6
    [<ffffffff813fe5bc>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

