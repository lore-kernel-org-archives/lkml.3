Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3JBMEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:04:09 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:43850 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3JBMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:04:05 -0400
Date: Wed, 2 Oct 2013 14:03:56 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org
Subject: mmap for /proc/vmcore broken since 3.12-rc1
Message-ID: <20131002140356.63706540@holzheu>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100212-8372-0000-0000-000007594A03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexey,

Looks like the following commit broke mmap for /proc/vmcore:

commit c4fe24485729fc2cbff324c111e67a1cc2f9adea
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Tue Aug 20 22:17:24 2013 +0300

    sparc: fix PCI device proc file mmap(2)

Because /proc/vmcore (fs/proc/vmcore.c) does not implement the
get_unmapped_area() fops function mmap now always returns EIO.

Michael

