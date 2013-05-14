Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab3ENP6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107Ab3ENP6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:58:30 -0400
Date: Tue, 14 May 2013 11:57:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH v5 5/8] vmcore: allocate ELF note segment in the 2nd
 kernel vmalloc memory
Message-ID: <20130514155755.GH13674@redhat.com>
References: <20130514015622.18697.77191.stgit@localhost6.localdomain6>
 <20130514015734.18697.32447.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514015734.18697.32447.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 10:57:35AM +0900, HATAYAMA Daisuke wrote:

[..]
> +/* Merges all the PT_NOTE headers into one. */
> +static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
> +					   char **notesegptr, size_t *notesegsz,
> +					   struct list_head *vc_list)
> +{

Given that we are copying notes in second kernel, we are not using vc_list
in merge_note_headers() any more. So remove vc_list from paramter list
here.

For local parameters we could simply use notes_buf (instead of notesgptr)
and notes_sz (instead of notesgsz). It seems mroe readable.

Thanks
Vivek
