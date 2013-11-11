Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3KKUyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:54:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab3KKUyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:54:06 -0500
Date: Mon, 11 Nov 2013 15:53:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Kexec query about what makes sure control pages/page tables are not
 overwritten
Message-ID: <20131111205341.GE11547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am staring at control page allocation logic in case of kdump and
wondering what makes sure that these pages are not overwritten by 
next kernel.

I see that for 64bit entry, control pages have the page tables needed
for second kernel. In case of crash these pages from from crash kernel
reserved region. Page allocator is very simple and that is start from
lowest crash reserved range and move higher and allocate first available
page which is not allocated to segments. What makes sure that these pages
are not overwritten by second kernel.

I guess it becomes a general bootloader question. How do we make sure
bootloader prepared page tables/gdt will not be overwritten by kernel
(till kernel sets up its own page tables and gdt) and how should we do the
allocation and placement.

Thanks
Vivek
