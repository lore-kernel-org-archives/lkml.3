Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaKLWMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:12:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaKLWMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:12:30 -0500
Date: Wed, 12 Nov 2014 17:12:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, kumagai-atsushi@mxc.nes.nec.co.jp,
        anderson@redhat.com
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in
 VMCOREINFO
Message-ID: <20141112221205.GB5265@redhat.com>
References: <20141112.154042.59640143160036130.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112.154042.59640143160036130.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 03:40:42PM +0900, HATAYAMA Daisuke wrote:
> Currently, VMCOREINFO note information reports the virtual address of
> phys_base that is assigned to symbol phys_base. But this doesn't make
> sense because to refer to value of the phys_base, it's necessary to
> get the value of phys_base itself we are now about to refer to.
> 

Hi Hatayama,

/proc/vmcore ELF headers have virtual address information and using
that you should be able to read actual value of phys_base. gdb deals
with virtual addresses all the time and can read value of any symbol
using those headers.

So I am not sure what's the need for exporting actual value of
phys_base.

Thanks
Vivek
