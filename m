Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3EQAHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 20:07:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51746 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3EQAHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 20:07:09 -0400
Message-ID: <51957469.2000008@zytor.com>
Date: Thu, 16 May 2013 17:06:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v6 0/8] kdump, vmcore: support mmap() on /proc/vmcore
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
In-Reply-To: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 02:05 AM, HATAYAMA Daisuke wrote:
> Currently, read to /proc/vmcore is done by read_oldmem() that uses
> ioremap/iounmap per a single page. For example, if memory is 1GB,
> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
> times. This causes big performance degradation.

read_oldmem() is fundamentally broken and unsafe.  It needs to be
unified with the plain /dev/mem code and any missing functionality fixed
instead of "let's just do a whole new driver".

	-hpa


