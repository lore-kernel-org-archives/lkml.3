Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3JHMt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:49:57 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:51140 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3JHMt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <52521FA5.3040101@jp.fujitsu.com>
References: <20131002140356.63706540@holzheu>
	<524D0ADF.2010507@jp.fujitsu.com>
	<52521FA5.3040101@jp.fujitsu.com>
Date: Tue, 8 Oct 2013 15:49:54 +0300
Message-ID: <CACVxJT8S7kA92=80DWVmVJJvbnaQ6WkyvsiFq4wP37WHV=tfuA@mail.gmail.com>
Subject: Re: mmap for /proc/vmcore broken since 3.12-rc1
From: Alexey Dobriyan <adobriyan@gmail.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 5:42 AM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:

> +static unsigned long
> +get_unmapped_area_vmcore(struct file *filp, unsigned long addr,
> +                        unsigned long len, unsigned long pgoff,
> +                        unsigned long flags)
> +{
> +#ifdef CONFIG_MMU
> +       return current->mm->get_unmapped_area(filp, addr, len, pgoff,
> flags);
> +#else
> +       return -EIO;
> +#endif
> +}
> +
>  static const struct file_operations proc_vmcore_operations = {
>         .read           = read_vmcore,
>         .llseek         = default_llseek,
>         .mmap           = mmap_vmcore,
> +       .get_unmapped_area = get_unmapped_area_vmcore,

I think current->mm->get_unmapped_area should be used by core proc code.
ENOMEM bug looks unrelated though.
