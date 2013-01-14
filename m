Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3ANTEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:04:39 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42681 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab3ANTEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:04:37 -0500
MIME-Version: 1.0
In-Reply-To: <201301141605.43428.trenn@suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<2741365.qqWvlU8HGl@hammer82.arch.suse.de>
	<CAE9FiQV+W21WcZuuWJYJKXhN4sf0mi=iAFgjX644c3EytPXptw@mail.gmail.com>
	<201301141605.43428.trenn@suse.de>
Date: Mon, 14 Jan 2013 11:04:36 -0800
X-Google-Sender-Auth: boJVeBJsff1OynX6j1gp2kdJYSE
Message-ID: <CAE9FiQVQvj1TPokoCgx_jbp0VACC8cgtFibH4KoqOssEc6JSPw@mail.gmail.com>
Subject: Re: [PATCH] x86 e820: only void usable memory areas in
 memmap=exactmap case
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 7:05 AM, Thomas Renninger <trenn@suse.de> wrote:
> What is this for?:
> @@ -871,6 +879,11 @@ static int __init parse_memmap_one(char
>         userdef = 1;
>         if (*p == '@') {
>                 start_at = memparse(p+1, &p);
> +               if (exactusablemap_parsed) {
> +                       /* remove all range with other types */
> +                       e820_remove_range(start_at, mem_size,
> +                                                E820_RAM, 0);
> +               }
>                 e820_add_region(start_at, mem_size, E820_RAM);
>         } else if (*p == '#') {
>                 start_at = memparse(p+1, &p);

remove all old renges before add E820_RAM, otherwise new add E820
ranges could be ignored.
