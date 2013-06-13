Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3FMBNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:13:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6067 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3FMBNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:13:35 -0400
X-Spam-Score: -100.8
Message-ID: <51B91C8C.5000002@asianux.com>
Date: Thu, 13 Jun 2013 09:12:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arm64: kernel: compiling issue, need delete read_current_timer().
References: <5199C725.8050102@asianux.com> <168084c28e8ba5124c05553e97463172@localhost> <20130520095606.GH31359@mudshark.cambridge.arm.com> <519AF2DC.2040200@asianux.com> <20130521085325.GB10453@mudshark.cambridge.arm.com> <519B425D.4030806@asianux.com> <51A32F40.1050309@asianux.com> <51B2B50A.1050305@asianux.com> <20130610085715.GA6580@mudshark.cambridge.arm.com>
In-Reply-To: <20130610085715.GA6580@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 04:57 PM, Will Deacon wrote:
> On Sat, Jun 08, 2013 at 05:37:30AM +0100, Chen Gang wrote:
>> > Hello Maintainers:
>> > 
>> > Please help check it, when you have time.
> [...]
> 

OK, thanks.

>>>> > >> Under arm64, we will calibrate the delay loop statically using a known
>>>> > >> timer frequency, so delete read_current_timer(), or it will cause
>>>> > >> compiling issue with allmodconfig.
>>>> > >>
>>>> > >> The related error:
>>>> > >>   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
>>>> > >>   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
>>>> > >>   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
>>>> > >>   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
>>>> > >>
>>>> > >>
>>>> > >> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> > >> ---
>>>> > >>  arch/arm64/include/asm/timex.h |    6 +++---
>>>> > >>  arch/arm64/kernel/time.c       |    6 ------
>>>> > >>  2 files changed, 3 insertions(+), 9 deletions(-)
> Looks ok to me. We'll take it for a spin and apply it if it doesn't catch
> fire.

Really need a carefully checking.

Thanks.
-- 
Chen Gang

Asianux Corporation
