Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3ERPCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 11:02:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3ERPCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 11:02:31 -0400
Message-ID: <51979801.7010903@dawncrow.de>
Date: Sat, 18 May 2013 17:02:25 +0200
From: =?ISO-8859-15?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>
Subject: Re: [PATCHv4] arm: Preserve the user r/w register TPIDRURW on context
 switch and fork
References: <518AA19B.2020209@dawncrow.de>
In-Reply-To: <518AA19B.2020209@dawncrow.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:YT9G4ss2spRrwgPfQh/A/LumG8r8Fac6pZGUSizyPdp
 Ws+0RfMOGat4Djk9OlpQrO6lNMd1v0YhVCl8/y5CD4mL04k5pD
 AVbCDlA4ZC3tZZq97P+ojJj8i7jKLwDiU2ZeGio7g1zdfy8M9n
 JysFkiXIaXvGNznVS5IOoicjOsx6UcLYclyNBm3Q7dVfo6jv++
 EoMkHQtQN0FKC7giGvcR6vwEyqYrShd2JGPP9yxKdcXHSKrOZ1
 mh80m/t+EV8Near/XWFG2rSWft6FvCcYOISvvWhSH2Q7ditol8
 DlQI5w7EeZMEuIU4a6Et2hM+JrI0pLsq0fTefccZQr1D1WwOEf
 VW2Hy1nViS3hwr5A5NkM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.05.2013 21:03, schrieb André Hentschel:
> From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
> 
> Since commit 6a1c53124aa1 the user writeable TLS register was zeroed to
> prevent it from being used as a covert channel between two tasks.
> 
> There are more and more applications coming to WinRT, Wine could support them,
> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
> 
> This patch preserves that register per thread instead of clearing it.
> Unlike the TPIDRURO, which is already switched, the TPIDRURW
> can be updated from userspace so needs careful treatment in the case that we
> modify TPIDRURW and call fork(). To avoid this we must always read
> TPIDRURW in copy_thread.
> 
> Signed-off-by: André Hentschel <nerv@dawncrow.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Jonathan Austin <jonathan.austin@arm.com> 
> 

Hi,
I'm not yet very familiar with the development process here,
am i getting no feedback on v4 because of the mergewindow being closed?
Or is there another reason? Sry for being impatient.
