Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3EUPtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:49:07 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:32977 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753370Ab3EUPtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:49:04 -0400
X-Greylist: delayed 9505 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 11:49:04 EDT
Message-ID: <519B976A.3050708@hurleysoftware.com>
Date: Tue, 21 May 2013 11:48:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>
CC: gregkh@linuxfoundation.org, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY:vt: convert remain take_over_console's users to do_take_over_console
References: <20130521051511.GA11435@udknight> <519B7249.2070207@hurleysoftware.com> <20130521144215.GA5302@udknight.homenetwork>
In-Reply-To: <20130521144215.GA5302@udknight.homenetwork>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 10:42 AM, Wang YanQing wrote:
> On Tue, May 21, 2013 at 09:10:33AM -0400, Peter Hurley wrote:
>> I would rather revert dc9641895abb which purported to delete
>> _unneeded_ functions than have this. Obviously the functions
>> were needed.
>>
>
> Hi Peter, this series patches' goal is to reduce codes'
> redundance and function duplication. But if we keep take_over_console,
> then we have to rewrite it as a trivial wrapper over do_take_over_console,
> or we have to keep bind_con_driver and register_con_driver, and this
> will bring use codes' redundance.
>
> And if we rewrite take_over_console as a wrapper over
> do_take_over_console, it is so trivial, delete it and let kernel
> use the unified version of APIs will simplify the APIs.

Except now you're spreading the brokenness that is console_lock()
over many more source files than the single-use case of
do_take_over_console().

The actual interface is take_over_console(); the _workaround_ is
exposing do_take_over_console() for fbcon to wrap.

Regards,
Peter Hurley

