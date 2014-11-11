Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaKKQcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:32:04 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46815 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKKQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:32:01 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1411111717270.2047@localhost6.localdomain6>
References: <1415708457-18798-1-git-send-email-octavian.purdila@intel.com>
	<1415708457-18798-2-git-send-email-octavian.purdila@intel.com>
	<alpine.DEB.2.02.1411111717270.2047@localhost6.localdomain6>
Date: Tue, 11 Nov 2014 18:32:00 +0200
Message-ID: <CAE1zotLOZX8Kfy=ajSLf0wredSWVvGt1LqO0bYUtzmugg_Ph8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: dln2: fix _dln2_transfer return code
From: Octavian Purdila <octavian.purdila@intel.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Lee Jones <lee.jones@linaro.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Johan Hovold <johan@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 6:18 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Tue, 11 Nov 2014, Octavian Purdila wrote:
>
>> If wait_for_completion_interruptible_timeout returns a positive value
>> it may be propagated as the return value of _dln2_transfer. This
>> contradicts the documentation of the function and exposes unnecessary
>> internals to the callers.
>>
>> This patch makes sure to set the return value to 0 in that case.
>
> I didn't keep around the code or the address of the git tree, but I wonder
> if this makes a later assignment of ret to 0 unnecessary?
>

Yes, you are right, we can skip setting it when ibuf is NULL. I will
send v2 that fixes this and the coding style issue.
