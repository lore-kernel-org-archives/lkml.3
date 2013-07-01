Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3GAWCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:02:05 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:62952 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:02:04 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <alpine.DEB.2.02.1307012342500.4013@ionos.tec.linutronix.de>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
	<1372694659-30176-4-git-send-email-james.hogan@imgtec.com>
	<alpine.DEB.2.02.1307012342500.4013@ionos.tec.linutronix.de>
Date: Mon, 1 Jul 2013 23:02:01 +0100
X-Google-Sender-Auth: KCr_dUx5DU0SxcKE2P6loZDvSCY
Message-ID: <CAAG0J98-mWk6p5hph14ttzBXbZmtDsQtoh8FF2DgoUA1MXv2VA@mail.gmail.com>
Subject: Re: [PATCH 3/5] metag: smp: don't spin waiting for CPU to start
From: James Hogan <james.hogan@imgtec.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 July 2013 22:46, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 1 Jul 2013, James Hogan wrote:
>> Use a completion to block until a secondary CPU has started up, like ARM
>> do, instead of a loop of udelays.
>>
>> On Meta, SMP is really SMT, with each "CPU" being a different hardware
>> thread on the same Meta processor core, so as well as being more
>> efficient and latency friendly, using a completion prevents the bogomips
>> of the secondary CPU from being drastically skewed every time by the
>> execution of the tight in-cache udelay loop on the other CPU.
>
> The least of our worries is the correctness of bogomips. But if that
> patch makes bogomips less bogus while fixing a real issue, please add
> my
>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Yes, it's not so much the absolute value, but that secondary cpus will
have a bogomips around 25% higher than the boot cpu, even though they
should be about equal (ignoring the effects of other cpus). If I
understand correctly, all else being equal this would make udelay
block for a different amount of time on different cpus (although I
haven't tried measuring it).

James
