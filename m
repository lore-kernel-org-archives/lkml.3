Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaFBR7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:59:43 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54950 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaFBR7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <538C2694.1090308@ladisch.de>
References: <1401659019-17586-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<538C2694.1090308@ladisch.de>
Date: Mon, 2 Jun 2014 19:59:39 +0200
Message-ID: <CAFo99gaF5ax4uVn1UCxqh5S158bYsiAtV9T6h3Z=zT0ucQzSyw@mail.gmail.com>
Subject: Re: [PATCH] arch: ia64: kernel: palinfo.c: Optimization of the Code
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-ia64@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thought I would be able to do that. But after testing, I could not
measure any difference.

Thought it would make a noticeable difference, but guess gcc resolve
this in the best way.


Best regards
Rickard Strandqvist


2014-06-02 9:24 GMT+02:00 Clemens Ladisch <clemens@ladisch.de>:
> Rickard Strandqvist wrote:
>> From what I know, AND is faster then modulo.
>
> Which is why the compiler does this optimization automatically,
> if it can prove that it is correct.
>
>> -             if (i != 0 && (i%64) == 0)
>> +             if (i != 0 && (i&63) == 0)
>
> Did you prove that i cannot be negative?
>
>
> Regards,
> Clemens
