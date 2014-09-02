Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaIBP0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:26:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbaIBP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:26:03 -0400
Message-ID: <5405E186.2080406@canonical.com>
Date: Tue, 02 Sep 2014 17:25:58 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ulf Winkelvos <ulf@winkelvos.de>, Matt Fleming <matt.fleming@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [REGRESSION] "efi: efistub: Convert into static library" and preparation
 patches
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

My macbook pro 8.2 fails to do a efi stub boot with these patches.

Commit f23cf8bd5c1f49 "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
causes the first break, but this can be averted by changing

struct efi_config *efi_early;

to

struct efi_config *efi_early __attribute__((visibility("hidden")));

I also need to revert commit f4f75ad5741fe "efi: efistub: Convert into static library"
to get boot working.

I'm not an early boot expert, so I have no idea what's going on here.
Only console output I see when the boot fails is "setup_efi_pci() failed!" after
the commit that adds this message.

~Maarten

