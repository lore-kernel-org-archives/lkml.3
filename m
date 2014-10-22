Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaJVRz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:55:57 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:37895 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaJVRz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <20141022171942.GC27405@n2100.arm.linux.org.uk>
References: <1413993983-17310-1-git-send-email-mathieu.poirier@linaro.org>
	<20141022161155.GB27405@n2100.arm.linux.org.uk>
	<CANLsYkwGtB0=VDFa-p11AGFA1XLjgGQGLa-U4WYtSs7-pHtVdw@mail.gmail.com>
	<20141022171942.GC27405@n2100.arm.linux.org.uk>
Date: Wed, 22 Oct 2014 19:55:55 +0200
Message-ID: <CANLsYkzPWnqLzhNpiKqM2jd8J4uZe4G7BL3fystXgHaE4_KkOQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: supplementing IO accessors with 64 bit capability
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        ezequiel.garcia@free-electrons.com, Liviu Dudau <Liviu.Dudau@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2014 19:19, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Oct 22, 2014 at 06:22:09PM +0200, Mathieu Poirier wrote:
>> I had this conversation with a colleague who reviewed the work.  If
>> the architecture is < 5 the __raw_ versions aren't included and the
>> compiler won't complain until someone tries to use the macros.  We
>> achieve the same result - the macros aren't accessible when the
>> architecture doesn't support it - while saving an #if condition in the
>> file.
>>
>> I'm not strongly opinionated on this - I can enclose the macros in an
>> #if statement.
>
> What you're missing is that some driver may test for their presence by
> doing:
>
> #ifndef readq_relaxed
> ... do something else
>
> which would now break as a detection method, as the macro is always
> defined no matter whether it's present or not.

Good point - thanks for showing me the light.

>
> --
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
