Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbaJaR6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:58:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17951 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537AbaJaR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:58:45 -0400
Message-ID: <5453CE48.406@oracle.com>
Date: Fri, 31 Oct 2014 14:00:40 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Commit 258801563b breaks on old compilers
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,


Your commit 258801563b ("x86/vdso: Change the PER_CPU segment to use 
struct desc_struct") in -tip breaks old compilers that don't support 
initialization of anonymous structures (I think pre-4.6):

FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap> cat anon.c
struct bar {
struct {
int i;
};
};

main()
{
struct bar a = {.i = 0};
}

FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap> gcc --version|head -1
gcc (GCC) 4.4.4 20100503 (Red Hat 4.4.4-2)
FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap> gcc anon.c
anon.c: In function ‘main’:
anon.c:9: error: unknown field ‘i’ specified in initializer
FC-64 <build@build-mk2:~/xtt-x86_64/bootstrap>


but

build@build-mk2 bootstrap]$ gcc --version|head -1
gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)
[build@build-mk2 bootstrap]$ gcc anon.c
[build@build-mk2 bootstrap]$


-boris
