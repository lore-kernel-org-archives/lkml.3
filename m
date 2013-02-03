Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3BCTdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:33:23 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:44166 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3BCTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:33:19 -0500
MIME-Version: 1.0
Date: Sun, 3 Feb 2013 21:33:18 +0200
Message-ID: <CAEPKs0fXY9WB+7kKPzOCt3HcGkLek3t_28GseZmX34Bu_14+NQ@mail.gmail.com>
Subject: Reason for playing games with vector number on x86-64 interrupt handling
From: Ilya Lesokhin <ilya.lesokhin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question related to interrupt handling on x86-64.

entry_64.s cains the following code:
     pushq_cfi $(~vector+0x80)       /* Note: always in signed byte range */
and later
     addq $-0x80,(%rsp)              /* Adjust vector to [-256,-1] range *
and then finally in irq.c
      unsigned vector = ~regs->orig_ax;

if I'm not mistaken regs->orig_ax contains ((~vector+0x80) -0x80) =
~vector and applying ~ again gives vector.

I was wondering, what is the reason for all those games with vector?
why not just push vector in the begging and save later instructions?

Please CC me in your answers.
Thanks,
Ilya
