Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaKKPcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:32:10 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43350 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaKKPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:32:08 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org>
	<CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com>
	<5461150B.2010907@codeaurora.org>
Date: Tue, 11 Nov 2014 07:31:58 -0800
In-Reply-To: <5461150B.2010907@codeaurora.org> (Stephen Boyd's message of
	"Mon, 10 Nov 2014 11:42:03 -0800")
Message-ID: <7hsihpois1.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> On 11/10/2014 10:54 AM, Kevin Hilman wrote:
>> On Wed, Oct 22, 2014 at 5:33 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> We rely on probe order of this driver to determine the line number for
>>> the uart port. This makes it impossible to know the line number
>>> when these devices are populated via DT. Use the DT alias
>>> mechanism to assign the line based on the aliases node.
>>>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> FYI... this patch hit linux-next and caused multiple boot failures on
>> qcom platforms[1] as of next-20141110.  I'm assuming this is because
>> the corresponding DTS changes have not hit linux-next yet.
>>
>> Kevin
>>
>> [1] http://status.armcloud.us/boot/?qcom
>
> Hmm the intention was to make it optional so that dts changes aren't
> necessary unless you want deterministic numbering. I screwed that up
> badly :/ Thanks for finding this.
>
> Greg, can you also apply this patch or squash it into the bad one?
>
> ----8<-----
>
> From: Stephen Boyd <sboyd@codeaurora.org>
> Subject: [PATCH] tty: serial: msm_serial: Don't required DT aliases
>
> If there isn't a DT alias then of_alias_get_id() will return
> -ENODEV. This will cause the msm_serial driver to fail probe,
> when we want to keep the previous behavior where we generated a
> dynamic line number at probe time. Restore this behavior by
> generating a dynamic id if the line number is still negative
> after checking for an alias or (in the non-DT case) looking at the
> .id field of the platform device.
>
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Tested-by: Kevin Hilman <khilman@linaro.org>

I confirm that this patch gets things booting again for the
msm8974/xperia-z1 and the apq8064/ifc6410.

Kevin
