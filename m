Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaIINLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:11:53 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:64867 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaIINLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:11:51 -0400
Message-ID: <540EFC99.3040100@linaro.org>
Date: Tue, 09 Sep 2014 14:11:53 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] asm-generic/io.h: Implement read[bwlq]_relaxed()
References: <1410264760-29756-1-git-send-email-daniel.thompson@linaro.org> <CAMuHMdWvyfPxHKWD3MkgDQRaf4xQUzVq561C1BHiNC_stQ-Rqw@mail.gmail.com>
In-Reply-To: <CAMuHMdWvyfPxHKWD3MkgDQRaf4xQUzVq561C1BHiNC_stQ-Rqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 13:31, Geert Uytterhoeven wrote:
> Hi Daniel,
> 
> On Tue, Sep 9, 2014 at 2:12 PM, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
>> Currently the read[bwlq]_relaxed() family are implemented on every
>> architecture except blackfin, m68k[1], metag, openrisc, s390[2] and
>> score. Increasingly drivers are being optimized to exploit relaxed
>> reads putting these architectures at risk of compilation failures for
>> shared drivers.
>>
>> This patch addresses this by providing implementations of
>> read[bwlq]_relaxed() that are identical to the equivalent read[bwlq]().
>> All the above architectures include asm-generic/io.h .
> 
> m68k does not include asm-generic/io.h.

Looking back through my command history I can't figure out how I made
this mistake.

I will change the comment.

For the record I have also just double checked blackfin, metag,
openrisc, s390 and score and these really do use asm-generic/io.h .


Daniel.

