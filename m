Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3GQUck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:32:40 -0400
Received: from 17.mo1.mail-out.ovh.net ([87.98.179.142]:41759 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754086Ab3GQUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:32:39 -0400
X-Greylist: delayed 17214 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Jul 2013 16:32:39 EDT
Message-ID: <51E6FF63.6050805@overkiz.com>
Date: Wed, 17 Jul 2013 22:32:35 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v2 24/42] ARM: at91: move at91sam9 boards to new at91
 clk implem
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com> <1374075433-20170-1-git-send-email-b.brezillon@overkiz.com> <20130717171343.GS24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130717171343.GS24642@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 18394952679247214771
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/2013 19:13, Russell King - ARM Linux wrote:
> On Wed, Jul 17, 2013 at 05:37:13PM +0200, Boris BREZILLON wrote:
>> Move at91 clk init from early_init to timer_init for all at91sam9 non dt
>> boards.
> Using black ball point pen, please complete the following sentence using
> as many words as you desire.  Additional underscores are available on
> request.
>
> The reason for this change is ______________________________________.
>
> Thanks. :)
Indeed, this commit message is a bit useless as it only describe what is 
done not why...

The reason for this is that dynamic allocator is not ready yet when 
early_init callback is called,
and new at91 clk implementation calls kzalloc functions.
It is moved in timer_init (before timer init) because at91sam9 init 
timer (pit timer) request the
mck clk which is registered by at91 clk init function.

I'll change this commit message in the next version.
