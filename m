Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3CTPDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:03:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47904 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab3CTPDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:03:44 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1363785354.2553.15.camel@x230.sbx07502.somerma.wayport.net>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com> <51490ABD.3050205@zytor.com> <1363785354.2553.15.camel@x230.sbx07502.somerma.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 20 Mar 2013 08:03:37 -0700
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Message-ID: <db71c48c-4ec4-4611-935b-bb1b0441112d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAP_SYS_RAWIO is definitely inappropriate there.

Matthew Garrett <matthew.garrett@nebula.com> wrote:

>On Tue, 2013-03-19 at 18:02 -0700, H. Peter Anvin wrote:
>
>> Looking at it in detail, EVERYTHING in CAP_SYS_RAWIO has the
>possibility
>> of compromising the kernel, because they let device drivers be
>bypassed,
>> which means arbitrary DMA, which means you have everything.
>
>Having checked again, I don't think this is true. The most obvious case
>is libata, which uses CAP_SYS_RAWIO to limit the ability to send raw
>ATA
>commands. Being able to do so clearly permits userspace to avoid any
>kind of policy the vfs has put in place, but there's no obvious way for
>the user to modify the running kernel. Are you suggesting that removing
>the CAP_SYS_RAWIO check there would be reasonable?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
