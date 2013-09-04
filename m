Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607Ab3IDAfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:35:54 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:37224 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761461Ab3IDAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:35:53 -0400
MIME-Version: 1.0
Date: Wed, 4 Sep 2013 03:35:52 +0300
Message-ID: <CA+i0qc5nimMyReOP0Z_Qc7aQSGUpiXiU14jxFqUBKd7mLd=eoA@mail.gmail.com>
Subject: drivers/char/hpet.c ACPI parsing
From: Tomas Winkler <tomasw@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hpet_resources function

Can anybody explain why we check fixmem32 for NULL, looks strange as
it derreferences  a member address

I'm asking since a static analyzer is complaining about it.

       } else if (res->id == ACPI_RSTYPE_FIXED_MEM32) {
              struct acpi_resource_fixed_mem32 *fixmem32;

               fixmem32 = &res->data.fixed_memory32;
               if (!fixmem32)
               ^^^^^^
                       return -EINVAL;

Thanks
Tomas
