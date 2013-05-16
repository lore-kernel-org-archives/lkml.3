Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3EPUdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab3EPUdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:33:15 -0400
Date: Thu, 16 May 2013 16:32:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v6 6/8] vmcore: allocate ELF note segment in the 2nd
 kernel vmalloc memory
Message-ID: <20130516203236.GG5904@redhat.com>
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
 <20130515090614.28109.26492.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515090614.28109.26492.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 06:06:14PM +0900, HATAYAMA Daisuke wrote:

[..]

> +static int __init get_note_number_and_size_elf32(const Elf32_Ehdr *ehdr_ptr,
> +						 int *nr_ptnote, u64 *phdr_sz)
> +{
> +	return process_note_headers_elf32(ehdr_ptr, nr_ptnote, phdr_sz, NULL);
> +}
> +
> +static int __init copy_notes_elf32(const Elf32_Ehdr *ehdr_ptr, char *notes_buf)
> +{
> +	return process_note_headers_elf32(ehdr_ptr, NULL, NULL, notes_buf);
> +}
> +

Please don't do this. We need to create two separate functions doing
two different operations and not just create wrapper around a function
which does two things.

I know both functions will have similar for loops for going through
the elf notes but it is better then doing function overloading based
on parameters passed.

Vivek
