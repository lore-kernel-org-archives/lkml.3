Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3CKOuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:50:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3CKOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:50:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: SYSV IPC broken for no-legacy syscall kernels (was Re: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker script)
Date: Mon, 11 Mar 2013 14:50:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Markos <markos.chandras@imgtec.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201303111330.15589.arnd@arndb.de> <513DE0C7.9030304@synopsys.com>
In-Reply-To: <513DE0C7.9030304@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111450.12067.arnd@arndb.de>
X-Provags-ID: V02:K0:zqZYdkKUJnU1BUW86Wq2eCQwqD3wlm7lNRyVu76Nyxm
 S79PU3jHg/cnsUoh/AusRBff3mzQ9VQjMMQ7CagWCYg8gxqQOw
 HKsRJoC2DuqsiRseCrmsoZPyZFYU1Dlk352v3pGp/4b6JkueZ/
 si1+X9XxatjeB98Yw8zfHj0R6qlSbl2pVSCVtV50mQhX2NZMY+
 /m84D1NW6rZOjwJE9WSjhz9wLaMlWUJFUmXs536Uew7FCoLp8l
 auM3Ydu5VDu2lJiDbhPc0wwoBkkDxH5rvi5zHy0kD2Ss4Ys6ts
 kMeWE2hL0SyeNQZaau3S5Gaz1KWi61umyLOnTyfY1WdnE/oQlK
 jdjkQT7EeTNYgfGZ4ksE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013, Vineet Gupta wrote:
> The question is what should the msgctl(2) ABI be w.r.t. @cmd arg. Does it need to
> be of type 0x01NN  (i.e. IPC_64 ORed) or should it be be 0xNN. If it's 0x01NN,
> then ARCH_WANT_IPC_PARSE_VERSION is needed in Kconfig, otherwise, I need to fix
> uClibc.
> 
> The reason for confusion seems to be a comment in existing uapi/linux/ipc.h which
> seems to suggest that IPC_OLD is 0 and IPC_64 is newer version.

Modern architecture ports should ignore this flag and always use the IPC_64 API,
there is no reason to maintain backwards compatibility with old binaries.

	Arnd
