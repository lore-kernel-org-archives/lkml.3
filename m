Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3KKU6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:58:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48819 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3KKU5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:57:49 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131111205341.GE11547@redhat.com>
References: <20131111205341.GE11547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Kexec query about what makes sure control pages/page tables are not overwritten
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 11 Nov 2013 12:57:12 -0800
To: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>
Message-ID: <15b29390-b535-4157-b7f2-8b1e03c919c1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is pretty simple: the kernel exports how much text+data+bss+brk it needs, and the kernel cannot use memory outside that region until it is ready to control the address space itself.

Vivek Goyal <vgoyal@redhat.com> wrote:
>Hi,
>
>I am staring at control page allocation logic in case of kdump and
>wondering what makes sure that these pages are not overwritten by 
>next kernel.
>
>I see that for 64bit entry, control pages have the page tables needed
>for second kernel. In case of crash these pages from from crash kernel
>reserved region. Page allocator is very simple and that is start from
>lowest crash reserved range and move higher and allocate first
>available
>page which is not allocated to segments. What makes sure that these
>pages
>are not overwritten by second kernel.
>
>I guess it becomes a general bootloader question. How do we make sure
>bootloader prepared page tables/gdt will not be overwritten by kernel
>(till kernel sets up its own page tables and gdt) and how should we do
>the
>allocation and placement.
>
>Thanks
>Vivek

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
