Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaJJVRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:17:48 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33375 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJJVRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <20141010204403.GA30018@birch.djwong.org>
References: <20141010204403.GA30018@birch.djwong.org>
Date: Fri, 10 Oct 2014 14:17:45 -0700
Message-ID: <CAMEtUuwmw2KUB4+vFmL-_iPXbCfYpBxisYEC0CLEbkqUFL7RPg@mail.gmail.com>
Subject: Re: kernel crash in bpf_jit on x86_64 when running nmap
From: Alexei Starovoitov <ast@plumgrid.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 1:44 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> Hi everyone,
>
> I was running nmap on a x86_64 qemu guest and experienced the following crash:
>
> # nmap -sS -O -vvv 192.168.122.1
> Starting Nmap 6.40 ( http://nmap.org ) at 2014-10-10 13:14 PDT
> Initiating ARP Ping Scan at 13:14
> Scanning 192.168.122.1 [1 port]
> <kaboom>
>
> dmesg output is as follows (I set net.core.bpf_jit_enable=2 the second time):
>
> [   32.376291] flen=3 proglen=82 pass=0 image=ffffffffc01ac65b
> [   32.377595] JIT code: 00000000: 55 48 89 e5 48 81 ec 28 02 00 00 48 89 9d d8 fd
> [   32.379243] JIT code: 00000010: ff ff 4c 89 ad e0 fd ff ff 4c 89 b5 e8 fd ff ff
> [   32.380984] JIT code: 00000020: 4c 89 bd f0 fd ff ff 31 c0 4d 31 ed 48 89 fb b8
> [   32.382606] JIT code: 00000030: 00 00 00 00 48 8b 9d d8 fd ff ff 4c 8b ad e0 fd
> [   32.384280] JIT code: 00000040: ff ff 4c 8b b5 e8 fd ff ff 4c 8b bd f0 fd ff ff
> [   32.385911] JIT code: 00000050: c9 c3
> [   32.386841] bpf_jit: proglen=265 != oldproglen=269

thanks for the report. The line above indicates that JIT tried to emit
4 byte longer program than during pre-final pass.
Will look at it asap.
