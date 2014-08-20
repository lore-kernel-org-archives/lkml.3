Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaHTRSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:18:23 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57731 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaHTRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:18:22 -0400
MIME-Version: 1.0
Date: Wed, 20 Aug 2014 11:18:21 -0600
Message-ID: <CAFSsvmrZ3adzO_eNTc_ZWB3QGpfjPybj6O=x1-=a9=02pSG2qw@mail.gmail.com>
Subject: amd_mce.c redundant if check?
From: Adam Duskett <aduskett@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have recently come upon this section of code in
arch/x86/kernel/cpu/mcheck/mce_amd.c that seems to be a redundant
unnecessary if check.


>From line 170 - 176:

if (tr->set_lvt_off) {
if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
/* set new lvt offset */
hi &= ~MASK_LVTOFF_HI;
hi |= tr->lvt_off << 20;
}
}


This seems like it's not actually doing anything because it's setting
the same value that the bit-field already has to itself.

Any reason for this?


Thanks!
