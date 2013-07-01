Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3GACkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 22:40:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33755 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3GACkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 22:40:17 -0400
X-Spam-Score: -100.8
Message-ID: <51D0EBDD.70804@asianux.com>
Date: Mon, 01 Jul 2013 10:39:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michael Schmitz <schmitzmic@gmail.com>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] arch: m68k: include: asm: define 'VM_DATA_DEFAULT_FLAGS'
 no matter whether has 'NOMMU' or not.
References: <51C548E2.1060104@asianux.com> <51C54A9B.9060009@asianux.com> <51CE9442.2020105@gmail.com> <CAMuHMdVAQJWDem0=uMnH7iVrckxPJ9cPn=8pYOusNov+wW5VeA@mail.gmail.com>
In-Reply-To: <CAMuHMdVAQJWDem0=uMnH7iVrckxPJ9cPn=8pYOusNov+wW5VeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 04:26 PM, Geert Uytterhoeven wrote:
> On Sat, Jun 29, 2013 at 10:01 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
>>> >> The same .config file, also report the compiling error below:
>>> >>
>>> >> drivers/i2c/busses/i2c-ocores.c:81:2: error: implicit declaration of
>>> >> function ‘iowrite8’ [-Werror=implicit-function-declaration]
>>> >> drivers/i2c/busses/i2c-ocores.c:86:2: error: implicit declaration of
>>> >> function ‘iowrite16’ [-Werror=implicit-function-declaration]
>>> >> drivers/i2c/busses/i2c-ocores.c:91:2: error: implicit declaration of
>>> >> function ‘iowrite32’ [-Werror=implicit-function-declaration]
>>> >> drivers/i2c/busses/i2c-ocores.c:96:2: error: implicit declaration of
>>> >> function ‘ioread8’ [-Werror=implicit-function-declaration]
>>> >> drivers/i2c/busses/i2c-ocores.c:101:2: error: implicit declaration of
>>> >> function ‘ioread16’ [-Werror=implicit-function-declaration]
>>> >> drivers/i2c/busses/i2c-ocores.c:106:2: error: implicit declaration of
>>> >> function ‘ioread32’ [-Werror=implicit-function-declaration]
>>> >>
>>> >> Excuse me, I am not quite familiar with the related hardware and m68k,
>>> >> I guess under m68k architecture, we need not this drivers, is it correct ?
> Until someone synthesizes the OpenCores i2c core together with the
> OpenCores 68000 core (they seem to have one), and tries to run uClinux
> on it...
> 

OK, thanks.

>> > That would be correct, yes. Perhaps add appropriate dependencies in
>> > drivers/i2c/Kconfig to allow building I2C drivers
>> > only on hardware that supports it?
> We still want it for compile-coverage.
> 
> Now, the issue is that m68knommu doesn't implement ioread8() and
> friends, so I'm adding the uClinux list.

Do you also add it to main tree (e.g next-tree), if not, I recommend to
do add it to main tree.


Thanks.
-- 
Chen Gang
