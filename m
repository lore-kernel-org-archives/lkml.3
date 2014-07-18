Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbaGRCne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 22:43:34 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:59516 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaGRCnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 22:43:32 -0400
MIME-Version: 1.0
In-Reply-To: <7103938.6xzUh5tnai@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-21-git-send-email-lftan@altera.com>
	<7103938.6xzUh5tnai@wuerfel>
Date: Fri, 18 Jul 2014 10:43:31 +0800
X-Google-Sender-Auth: mC7Y2e5fROGMyJWWjzLTb0mkP8I
Message-ID: <CAFiDJ5-KFmf9-YBnvZae7iwMWwb6XOgOLUFA+9eRLvuk_TDXnw@mail.gmail.com>
Subject: Re: [PATCH v2 20/29] nios2: Cpuinfo handling
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 July 2014 16:45:47 Ley Foon Tan wrote:
>> +static void *cpuinfo_start(struct seq_file *m, loff_t *pos)
>> +{
>> +       unsigned long i = *pos;
>> +
>> +       return i < num_possible_cpus() ? (void *) (i + 1) : NULL;
>> +}
>> +
>> +static void *cpuinfo_next(struct seq_file *m, void *v, loff_t *pos)
>> +{
>> +       ++*pos;
>> +       return cpuinfo_start(m, pos);
>> +}
>
> Do you actually have SMP support?
Not.


>> +const struct seq_operations cpuinfo_op = {
>> +       .start  = cpuinfo_start,
>> +       .next   = cpuinfo_next,
>> +       .stop   = cpuinfo_stop,
>> +       .show   = show_cpuinfo
>> +};
>
> If not, you can use single_start/next/stop here rather than defining your own.
Okay, I will look into your suggestion.
Thanks.

Regards
Ley Foon
