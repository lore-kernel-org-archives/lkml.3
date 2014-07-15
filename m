Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbaGOJre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:47:34 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56245 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530AbaGOJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:47:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 20/29] nios2: Cpuinfo handling
Date: Tue, 15 Jul 2014 11:47:28 +0200
Message-ID: <7103938.6xzUh5tnai@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405413956-2772-21-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-21-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CXUO2LLNHEntqzk0KqdWohbIotamj5bSwg5A7NmmAz9
 YTsv7u0MYu33fZJ0ur122It9FwnIL7sMTf6uyvrZXTIE7iLsHY
 sIgn9JMWFDm1RbyPctMQg2wLmnuSyQkQ3E8O1j9i7cmDfPPzMk
 J2OakFz0MojpgbjdFzCBICPKP3bH3jz9QCnnqrkn2Bf+BDX+yU
 LNANiBOX4VkYelYaRk/nxEQjr4ygJxscwWGXsJPiURl0/3Rabs
 w2g3mk4Ahc6iUNWJMntWHwXaJX7qLURPyjDs8iYZVbI44EThWh
 87Ro0fGq3a3XNGTiQ9nzNc+XYTp1oI7vwfgnk3weEsL28uW9CM
 JEaFxgVOhO4RAbqFH5yw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2014 16:45:47 Ley Foon Tan wrote:
> +static void *cpuinfo_start(struct seq_file *m, loff_t *pos)
> +{
> +       unsigned long i = *pos;
> +
> +       return i < num_possible_cpus() ? (void *) (i + 1) : NULL;
> +}
> +
> +static void *cpuinfo_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +       ++*pos;
> +       return cpuinfo_start(m, pos);
> +}

Do you actually have SMP support?

> +const struct seq_operations cpuinfo_op = {
> +       .start  = cpuinfo_start,
> +       .next   = cpuinfo_next,
> +       .stop   = cpuinfo_stop,
> +       .show   = show_cpuinfo
> +};

If not, you can use single_start/next/stop here rather than defining your own.

	Arnd
