Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbbAXLCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:02:33 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:54071 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAXLC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:02:29 -0500
MIME-Version: 1.0
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B73270D4C5@PGSMSX105.gar.corp.intel.com>
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>
	<1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
	<AF233D1473C1364ABD51D28909A1B1B73270D4C5@PGSMSX105.gar.corp.intel.com>
Date: Sat, 24 Jan 2015 13:02:28 +0200
Message-ID: <CAHp75VcCcpUZ7AuKk96-aVUd6Vykfc8_yod+8T_at2DMuTve3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 3:48 AM, Ong, Boon Leong
<boon.leong.ong@intel.com> wrote:

>>+static int imr_enabled(struct imr_regs *imr)
> Do we want to make it inline perhaps since it is 1 liner?

Since it is declared static I would even suggest the new name is_imr_enabled().

[]

>>+int imr_remove_range(int reg, unsigned long base, unsigned long size)
>>+{
>>+      struct imr_regs imr;
>>+      int found = 0, i, ret = 0;
> Please make each of the defined variables as individual line here..

I would suggest to type i as unsigned int and found as bool.

[]

>>+              if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK) {
>>+                      ret = -ENODEV;
>>+                      goto done;
>>+              }
>>+              found = 1;
>>+

Redundant empty line.

>>+      } else {
>>+              /* Search for match based on address range */
>>+              for (i = 0; i < imr_dev.max_imr; i++) {
>>+                      ret = imr_read(reg, &imr);
> A serious bug here.... 'reg' should be 'i' . We enter this branch if reg=-1
> Is there a miss in your test case?
>
>>+                      if (ret)
>>+                              goto done;
>>+
>>+                      if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK)
>>+                              continue;
>>+
>>+                      if ((imr_to_phys(imr.addr_lo) == base) &&
>>+                          (imr_to_phys(imr.addr_hi) == max)) {
> I think we need to take care of the size that has been fix-up here ...
>
>>+                              found = 1;
>>+                              reg = i;

According to your comment this line becomes redundant.

[]

>>+static void __init imr_fixup_memmap(void)
>>+{
>>+      unsigned long base  = virt_to_phys(&_text);
>>+      unsigned long size = virt_to_phys(&__end_rodata) - base;
> What about the size fixup to be consistent?
> We should not guard more than it is needed .....
>
>>+      int i, ret;
> Two int declaration line here.

unsigned int i; ?

-- 
With Best Regards,
Andy Shevchenko
