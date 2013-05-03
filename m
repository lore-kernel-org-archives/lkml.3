Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873Ab3ECJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:09:29 -0400
Received: from multi.imgtec.com ([194.200.65.239]:38522 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab3ECJJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:09:28 -0400
Message-ID: <51837EC3.30705@imgtec.com>
Date: Fri, 3 May 2013 10:09:23 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 6/8] gpio-tz1090: add TZ1090 gpio driver
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-7-git-send-email-james.hogan@imgtec.com> <CACRpkdbzYpQqe4yabAwFSAG2rPstT8jM_--LssHi=ttUYtu1ug@mail.gmail.com> <517A475D.8060606@imgtec.com> <CACRpkdZzfegengBJ4n1Yc1WQU9TT7+-n3VoHiBA+AG68CJEyiw@mail.gmail.com>
In-Reply-To: <CACRpkdZzfegengBJ4n1Yc1WQU9TT7+-n3VoHiBA+AG68CJEyiw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_03_10_09_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 03/05/13 09:49, Linus Walleij wrote:
> On Fri, Apr 26, 2013 at 11:22 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> So basically a bunch of global registers (e.g. pinctrl and gpio) are
>> shared between all 3 cores (up to 4 OSes). The __global_lock2 should do
>> all that is required to ensure exclusive access to the register (as long
>> as the other OSes do something similar when they access the same
>> registers). This is one of the reasons why there are 3 gpio banks with
>> separate interrupts, and each bank's interrupt is optional in this driver.
> 
> OK I get it ...
> 
> I think this platform will never ever work with single zImage
> though, that seems very unlikely given these constraints.
> 
> Well you will have to fight this out with the ARM SoC maintainers
> anyway. If they are OK with it I will live with it.
> 
> (CC ARM SoC for this.)

Sorry, I wasn't very clear. This driver runs on a Meta core (i.e.
arch/metag) not an ARM core, and <asm/global_lock.h> is an architecture
thing (LOCK{0,1,2} are instructions).

Cheers
James

