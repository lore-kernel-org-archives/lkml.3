Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626Ab3IDAQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:16:12 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:34571 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761612Ab3IDAQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:16:10 -0400
MIME-Version: 1.0
Date: Wed, 4 Sep 2013 03:16:09 +0300
Message-ID: <CA+i0qc6GH2Otr7MkTyXLA+DLK37cDoGmkmu+ymVicq8g+fo9SQ@mail.gmail.com>
Subject: drivers/char/hpet.c check
From: Tomas Winkler <tomasw@gmail.com>
To: ": Randy Dunlap" <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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
