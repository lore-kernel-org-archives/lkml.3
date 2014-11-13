Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455AbaKMW4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:56:12 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:46156 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMW4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:56:11 -0500
Message-ID: <546536EA.4070705@laposte.net>
Date: Thu, 13 Nov 2014 23:55:38 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: BUG in scsi_lib.c due to a bad commit
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net> <54647C10.4070506@laposte.net> <20141113142907.GB29354@infradead.org> <5464E6E6.3090606@laposte.net> <20141113175402.GA27327@infradead.org>
In-Reply-To: <20141113175402.GA27327@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrjedvgdejhecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefheenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

> Please explicitly test commits:
>
> 71e75c97f97a9645d25fbf3d8e4165a558f18747

with commit 71e75c97f97a9645d25fbf3d8e4165a558f18747 there is no problem


> and
>
> 74665016086615bbaa3fa6f83af410a0a4e029ee

it's interesting, with this commit
74665016086615bbaa3fa6f83af410a0a4e029ee I have the bug :

scsi: convert host_busy to atomic_t :

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=74665016086615bbaa3fa6f83af410a0a4e029ee

Le 13/11/2014 18:54, Christoph Hellwig a écrit :
> On Thu, Nov 13, 2014 at 06:14:14PM +0100, Barto wrote:
>> Hello Christoph,
>>
>> I tested this commit :
>>
>> 7ae65c0f9646c29432b69580b80e08632e6cd813 scsi: convert target_busy to an
>> atomic_t
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7ae65c0f9646c29432b69580b80e08632e6cd813
>>
>> there is no bug, boot process is ok whit this commit,
>>
>> when I did the "git bisect" the first bad commit was Guenters' commit (
>> 045065d8a300a37218c548e9aa7becd581c6a0e8 ), it seems that all commits
>> before 045065d8a300a37218c548e9aa7becd581c6a0e8 are ok,
> 
> The bisect isn't quite interesting here as we're trying to find the real
> root ause.
> 
> 045065d8a300a37218c548e9aa7becd581c6a0e8 reverts the polarity of the
> check that 71e75c97f97a9645d25fbf3d8e4165a558f18747 incorrectly
> chaged.
> 
> The behavior you see doesn't make a lot of sense from a high level view,
> so we need to find out what's going on.
> 
> When you say all commits before 045065d8a300a37218c548e9aa7becd581c6a0e8
> I wonder if the bisect simply skiped to many revisions.
> 
> Please explicitly test commits:
> 
> 71e75c97f97a9645d25fbf3d8e4165a558f18747
> 
> and
> 
> 74665016086615bbaa3fa6f83af410a0a4e029ee
> 
> Thanks!
> 
> 
